/* Factorial using STD loop and recursive calls
 * Author: Uwe Meyer-Baese
 */
unsigned char fact(unsigned char n);
unsigned char N, f, r, i;

void main()
{   
    N= 5; f=1;
	for (i=1; i<=N; i++) f = f * i;
	r= fact(N);
	
}
unsigned char fact(unsigned char n)
{ 
  if (n==0)
    return 1;
  else 
	return (n * fact (n-1));
}
