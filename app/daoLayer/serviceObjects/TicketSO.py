from datetime import datetime
from uuid import UUID

from pydantic import BaseModel
from typing import Optional


class TicketSO(BaseModel):
    id: Optional[UUID] = None
    title: str
    description: str
    status: Optional[str] = "open"
    severity: Optional[str] = "medium"
    category: Optional[str] = "others"
    assignee: Optional[str] = None
    created_at: datetime
