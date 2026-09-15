# Japanese revision comparison

The two Japanese images differ at 46,167 byte positions. Bank `$1B` is the only
identical 16 KiB bank. Counts below are byte-position differences, not semantic
change counts.

| Bank | Differing bytes | First ROM offset | Last ROM offset |
|---:|---:|---:|---:|
| `$00` | 13108 | `$00051` | `$03FFF` |
| `$01` | 11804 | `$04795` | `$07FFF` |
| `$02` | 18 | `$08A49` | `$0BFFF` |
| `$03` | 366 | `$0C532` | `$0FFFF` |
| `$04` | 233 | `$11AFB` | `$13FFF` |
| `$05` | 83 | `$17C2D` | `$17FFF` |
| `$06` | 348 | `$18E68` | `$1BFFF` |
| `$07` | 560 | `$1C222` | `$1FFFF` |
| `$08` | 60 | `$20004` | `$20FEF` |
| `$09` | 519 | `$27DCE` | `$27FFF` |
| `$0A` | 14 | `$2BF92` | `$2BFFF` |
| `$0B` | 13 | `$2FE80` | `$2FFFF` |
| `$0C` | 32 | `$33F83` | `$33FFE` |
| `$0D` | 65 | `$373AF` | `$37FA8` |
| `$0E` | 79 | `$39AF2` | `$3BFFF` |
| `$0F` | 15402 | `$3C04D` | `$3FFFF` |
| `$10` | 135 | `$40001` | `$43FFF` |
| `$11` | 307 | `$4410C` | `$47FFF` |
| `$12` | 406 | `$480EC` | `$4BFFF` |
| `$13` | 36 | `$4FD11` | `$4FFFF` |
| `$14` | 379 | `$50C01` | `$53FFF` |
| `$15` | 313 | `$55250` | `$57FFF` |
| `$16` | 330 | `$58D9D` | `$5BFFF` |
| `$17` | 397 | `$5C0B1` | `$5FFFF` |
| `$18` | 359 | `$6042D` | `$63FFF` |
| `$19` | 32 | `$67FE0` | `$67FFF` |
| `$1A` | 2 | `$6BFF4` | `$6BFFF` |
| `$1B` | 0 | — | — |
| `$1C` | 203 | `$70009` | `$73FFF` |
| `$1D` | 425 | `$74068` | `$77FFF` |
| `$1E` | 132 | `$78C8C` | `$7BFFF` |
| `$1F` | 7 | `$7C3F0` | `$7FFFF` |

Large counts in banks `$00`, `$01`, and `$0F` indicate that raw byte counts
must not be treated as bug-fix counts. Semantic comparison follows only after
labels, pointers, text, and data structures are established.

