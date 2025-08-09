# Inline C# Code

Here's some inline C# code: `var name = "Julius";`

## C# Code Block

```c_sharp
void SomeMethod()
{
    Console.WriteLine("Hello World!");
    
    var numbers = new List<int> { 1, 2, 3, 4, 5 };
    
    foreach (var num in numbers)
    {
        Console.WriteLine($"Number: {num}");
    }
}

public class Calculator
{
    public int Add(int a, int b)
    {
        return a + b;
    }
    
    public async Task<string> GetDataAsync()
    {
        await Task.Delay(1000);
        return "Data retrieved";
    }
}
```

## Python Code Block

```python
def calculate_average(numbers):
    """Calculate average of numbers."""
    if not numbers:
        return 0.0
    return sum(numbers) / len(numbers)

class DataProcessor:
    def __init__(self, name):
        self.name = name
    
    def process(self, data):
        return [item.upper() for item in data]
```

## JavaScript Code Block

```javascript
function fetchData(url) {
    return fetch(url)
        .then(response => response.json())
        .then(data => {
            console.log('Data received:', data);
            return data;
        })
        .catch(error => {
            console.error('Error:', error);
        });
}
```

This markdown file should now have proper syntax highlighting for all code blocks!
