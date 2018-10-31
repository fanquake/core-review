#include <iostream>
#include <locale>

int main(void) {
    setlocale(LC_ALL, "");
    std::cout << std::isspace(133) << ' ' << std::isspace(154) << ' ' << std::isspace(160);
    std::cout << '\n';
}
