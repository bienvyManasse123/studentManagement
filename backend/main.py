from fastapi import FastAPI, Depends, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy.orm import Session
import models, crud, schemas
from database import engine, get_db

models.Base.metadata.create_all(bind=engine)

app = FastAPI(title='API Gestion Étudiants', version='1.0.0')

app.add_middleware(
    CORSMiddleware,
    allow_origins=['*'],
    allow_methods=['*'],
    allow_headers=['*'],
)

@app.get('/')
def root(): return {'message': 'API Étudiants opérationnelle'}

@app.get('/etudiants', response_model=list[schemas.EtudiantResponse])
def liste(db: Session = Depends(get_db)):
    return crud.get_all(db)

@app.post('/etudiants', response_model=schemas.EtudiantResponse, status_code=201)
def ajouter(data: schemas.EtudiantCreate, db: Session = Depends(get_db)):
    return crud.create(db, data)

@app.put('/etudiants/{numEt}', response_model=schemas.EtudiantResponse)
def modifier(numEt: int, data: schemas.EtudiantUpdate, db: Session = Depends(get_db)):
    et = crud.update(db, numEt, data)
    if not et: raise HTTPException(404, 'Étudiant non trouvé')
    return et

@app.delete('/etudiants/{numEt}')
def supprimer(numEt: int, db: Session = Depends(get_db)):
    if not crud.delete(db, numEt): raise HTTPException(404, 'Étudiant non trouvé')
    return {'message': 'Supprimé avec succès'}

@app.get('/statistiques', response_model=schemas.StatistiquesResponse)
def statistiques(db: Session = Depends(get_db)):
    stats = crud.get_stats(db)
    if not stats: raise HTTPException(404, 'Aucun étudiant')
    return stats
