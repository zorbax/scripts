import sys


def heart(word: str, background: str = " "):
    return "\n".join(
        [
            "".join(
                [
                    (
                        word[(x - y) % len(word)]
                        if ((x * 0.04) ** 2 + (y * 0.1) ** 2 - 1) ** 3
                        - (x * 0.04) ** 2 * (y * 0.1) ** 3
                        <= 0
                        else background
                    )
                    for x in range(-40, 40)
                ]
            )
            for y in range(15, -15, -1)
        ]
    )


print(heart(str(sys.argv[1])))
