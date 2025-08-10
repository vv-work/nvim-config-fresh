#include <iostream>
#include <istream>
#include <string>

int main() {
    // std::string name;
    std::string name;
    std::string greeting = "Hello, ";
    std::cout << "Enter your name: ";
    std::getline(std::cin, name);
    std::cout << "Hello, " << name << "!" << std::endl;
    return 0;
}
// This program prompts the user for their name and greets them.
// It uses the standard input/output libraries to handle user interaction.
//
// To compile this program, use the following command:
// g++ hello.cpp -o hello
// To run the program, use:
// ./hello.cpp  // Make sure you have a C++ compiler installed, such as g++.
// The program will wait for user input and then display a greeting message.
// This is a simple example of a C++ program that demonstrates basic input/output operations.
