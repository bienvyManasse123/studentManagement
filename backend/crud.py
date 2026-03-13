from sqlalchemy.orm import Session
from sqlalchemy import func
from models import Etudiant
from schemas import EtudiantCreate, EtudiantUpdate

def get_all(db: Session):
    return db.query(Etudiant).order_by(Etudiant.numEt.desc()).all()

def get_one(db: Session, numEt: int):
    return db.query(Etudiant).filter(Etudiant.numEt == numEt).first()

def create(db: Session, data: EtudiantCreate):
    et = Etudiant(**data.model_dump())
    db.add(et); db.commit(); db.refresh(et)
    return et

def update(db: Session, numEt: int, data: EtudiantUpdate):
    et = get_one(db, numEt)
    if not et: return None
    for k, v in data.model_dump().items(): setattr(et, k, v)
    db.commit(); db.refresh(et)
    return et

def delete(db: Session, numEt: int):
    et = get_one(db, numEt)
    if not et: return False
    db.delete(et); db.commit()
    return True

def get_stats(db: Session):
    students = get_all(db)
    if not students:
        return None
    moyennes = [(s.nomEt, s.moyenne) for s in students]
    vals = [m[1] for m in moyennes]
    return {
        'total': len(students),
        'admis': sum(1 for v in vals if v >= 10),
        'redoublants': sum(1 for v in vals if v < 10),
        'moyenne_classe': sum(vals) / len(vals),
        'moyenne_min': min(vals),
        'moyenne_max': max(vals),
        'nom_min': min(moyennes, key=lambda x: x[1])[0],
        'nom_max': max(moyennes, key=lambda x: x[1])[0],
    }
