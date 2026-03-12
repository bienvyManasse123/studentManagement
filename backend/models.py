from sqlalchemy import Column, Integer, String, Float
from database import Base

class Etudiant(Base):
    __tablename__ = 'etudiants'

    numEt  = Column(Integer, primary_key=True, index=True, autoincrement=True)
    nomEt  = Column(String(100), nullable=False)
    note_math = Column(Float, nullable=False)
    note_phys = Column(Float, nullable=False)

    @property
    def moyenne(self) -> float:
        return (self.note_math + self.note_phys) / 2
