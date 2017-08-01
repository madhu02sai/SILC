#include <iostream>
using namespace std;


class class2 {
public:
    int y;
    class2()
    {
        y = 10;
    }
    void print() const
    {
        cout << y << endl;
    }
};

class class1 {
public:
    int x;
    class1()
    {
        x = 0;
    }
    void accessclass2(const class2 & cl2)
    {
        cl2.print();
    }
};
int main()
{
	class1 obj1;
	class2 obj2;
	obj1.accessclass2(obj2);
	return 0;
}
