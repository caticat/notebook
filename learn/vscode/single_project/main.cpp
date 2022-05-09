#include <iostream>
#include <map>

using namespace std;

int main()
{
	cout << 123 << endl;
	int a = 123;
	map<int, int> mapA;
	mapA[1] = 10;
	mapA[2] = 30;
	mapA[3] = 40;

	for (const auto& p : mapA)
	{
		cout << p.first << "->" << p.second << endl;
	}

	return 0;
}
