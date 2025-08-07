"""
Test file for Pyright LSP features.
"""

from typing import List, Optional

def calculate_average(numbers: List[float]) -> float:
    if not numbers:
        return 0.0
    return sum(numbers) / len(numbers)

def find_user(users: List[dict], user_id: int) -> Optional[dict]:
    for user in users:
        if user.get('id') == user_id:
            return user
    return None

class Calculator:
    def __init__(self, name: str):
        self.name = name
        self.history: list[float] = []

    def add(self, amount: float) -> None:
        self.value += amount

    def subtract(self, amount: float) -> None:
        self.value -= amount

    def get_value(self) -> float:
        return self.value
