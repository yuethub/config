/***********************************************************
 * 本文件是计算机网络第七版中第五章udp数据报校验和计算的实现与测试.
 ***********************************************************/
#include <inttypes.h>   // PRIu8 PRIx16
#include <math.h>       // pow()
#include <stdio.h>      // printf()

/*
 * @brief 计算UDP数据校验和，采用二进制补码加法运算，具体来说，0+1=1+0=1，0+0=1，1+1=10
 *      如果最高位发生溢出，则将溢出部分移到最低为继续相加.
 * @param dat: udp数据报（包括12字节伪首部，8字节udp首部和数据部分）
 * @param n: udp数据报的大小（以16字节为单位）
 * @retval: 校验和结果
 */

uint16_t checksum(uint16_t *dat, size_t n)
{
    uint32_t result;
    result = dat[0];
    for (size_t i = 1; i < n; i++) {
        result += dat[i];
        while (result > 65535) // 判断最高位是否溢出
            result = (result & 0x0000ffff) + 1;
    }
    return ~((uint16_t)result); // 对结果取反
}

/*
 * @brief 以二进制形式打印给定整数
 * @param var: 需要打印的整数
 * @retval None
 */
void printToBin(uint16_t var)
{
    uint8_t buf[16];
    for (int i = 0; i < 16; i++) {
        buf[i] = var / (unsigned int)pow(2, 15 - i);
        var = var % (unsigned int)pow(2, 15 - i);
    }
    for (int i = 0; i < 16; i++) {
        printf("%"PRIu8, buf[i]);
        if (i == 7)
            printf(" ");
    }
    printf("\n");
}

int main()
{
    // 用于测试的udp数据报
    uint16_t dat[] = {
        0x9913U, 0x0868U, 0xab03U, 0x0e0bU,
        0x0011U, 0x000fU, 0x043fU, 0x000dU,
        0x000fU, 0x0000U, 0x5445U, 0x5354U,
        0x494eU, 0x4700U
    };
    for (int i = 0; i < 14; i++) {
        printf("0x%04" PRIx16 ": ", dat[i]);
        printToBin(dat[i]);
    }
    uint16_t result = checksum(dat, 14);
    printf("result: 0x%04" PRIx16 ":  ", result);
    printToBin(result);
    return 0;
}
