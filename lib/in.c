#include <neko.h>
#include <stdio.h>
value input(){
    char str1[3500];
    scanf("%3499s", str1);
    return neko_alloc_string(str1);
}
DEFINE_PRIM(input,0);