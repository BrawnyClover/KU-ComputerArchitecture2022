#include <stdio.h>
#pragma warning(disable:4996)

void func1()
{
	int m, n;
	scanf("%d %d", &m, &n);
	int i, j;
	j = 2;
	i = m;
	int isPrime = 0;
	int cnt = 0;
	goto OUTER_LOOP1;

OUTER_LOOP1:
	isPrime = 1;
	j = 2;
	if (i == n) {
		goto EXIT; // beq
	}
	goto ISPRIME_LOOP;

OUTER_LOOP2:
	if (isPrime == 1) {
		cnt = cnt + 1;
	}
	i = i + 1;
	goto OUTER_LOOP1;

ISPRIME_LOOP:
	if (j == i) {
		goto OUTER_LOOP2; // beq
	}
	if (i % j == 0) {
		isPrime = 0;
		goto OUTER_LOOP2;
	}
	j = j + 1;
	goto ISPRIME_LOOP;

EXIT:
	printf("%d", cnt);
	return 0;
}

void func2()
{
	int num[10];
	int n, m;
	int i = 0;
	goto SCAN_LOOP;

NEXT_STAGE:
	scanf("%d", &m);
	int st = 0;
	int ed = 9;
	int md = 0;
	goto BINARY;

SCAN_LOOP:
	scanf("%d", &n);
	num[i] = n;
	i = i + 1;
	if (i == 10) {
		goto NEXT_STAGE;
	}
	goto SCAN_LOOP;

BINARY:
	md = st + ed;
	md = md / 2;
	if (num[md] == m) { // beq
		goto EXIT;
	}
	if (num[md] > m) {
		ed = md - 1;
		goto BINARY;
	}
	if (num[md] < m) {
		st = md + 1;
		goto BINARY;
	}

EXIT:
	printf("%d", m);
	return;
}

void func3()
{
	int n, m;
	scanf("%d %d", &n, &m);
	int cnt = 1;

GREEDY:
	printf("%d %d\n", m, cnt);
	if (m == n) {
		goto EXIT; // beq
	}
	if (m < n) {
		cnt = -1;
		goto EXIT;
	}
	if (m % 2 == 0) {
		m = m / 2;
		cnt = cnt + 1;
		goto GREEDY;
	}
	if (m % 10 == 1) {
		m = m - 1;
		m = m / 10;
		cnt = cnt + 1;
		goto GREEDY;
	}
EXIT:
	printf("%d", cnt);
	return 0;
}

int main()
{
	func1();
	func2();
	func3();
	return;
}

