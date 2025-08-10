# Multi-Language Code Testing

## Inline Code Examples
- C#: `var name = "Julius";`
- C++: `std::string name = "Julius";`
- Python: `name = "Julius"`

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

## C++ Code Block

```cpp
#include <iostream>
#include <vector>
#include <string>
#include <algorithm>

class Calculator {
private:
    std::vector<double> history;
    
public:
    Calculator() = default;
    
    double add(double a, double b) {
        double result = a + b;
        history.push_back(result);
        return result;
    }
    
    template<typename T>
    void processData(const std::vector<T>& data) {
        std::cout << "Processing " << data.size() << " items" << std::endl;
        
        auto filtered = data;
        std::remove_if(filtered.begin(), filtered.end(), 
                      [](const T& item) { return item == T{}; });
        
        std::cout << "Filtered to " << filtered.size() << " items" << std::endl;
    }
};

int main() {
    Calculator calc;
    double result = calc.add(10.5, 20.3);
    std::cout << "Result: " << result << std::endl;
    
    std::vector<int> numbers = {1, 2, 3, 4, 5};
    calc.processData(numbers);
    
    return 0;
}
```

## Alternative C++ Block

```c++
// Modern C++20 features
#include <ranges>
#include <concepts>

template<std::integral T>
constexpr T fibonacci(T n) {
    if (n <= 1) return n;
    return fibonacci(n-1) + fibonacci(n-2);
}

auto processRange() {
    std::vector<int> data = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
    
    auto result = data 
        | std::views::filter([](int x) { return x % 2 == 0; })
        | std::views::transform([](int x) { return x * x; })
        | std::views::take(3);
    
    return result;
}
```

This markdown file should now have proper syntax highlighting for all code blocks including C++!
