from pydantic import BaseModel, Field

class EtudiantBase(BaseModel):
    nomEt: str      = Field(..., min_length=2, max_length=100)
    note_math: float = Field(..., ge=0, le=20)
    note_phys: float = Field(..., ge=0, le=20)

class EtudiantCreate(EtudiantBase):
    pass

class EtudiantUpdate(EtudiantBase):
    pass

class EtudiantResponse(EtudiantBase):
    numEt: int
    moyenne: float

    class Config:
        from_attributes = True

class StatistiquesResponse(BaseModel):
    total: int
    admis: int
    redoublants: int
    moyenne_classe: float
    moyenne_min: float
    moyenne_max: float
    nom_min: str
    nom_max: str
