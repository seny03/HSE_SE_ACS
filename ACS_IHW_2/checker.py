import os
import subprocess
from tqdm import tqdm
import numpy as np

from bisect_search import f, find_root

PROJECT_PATH = r'D:\Programms\RARS\projects\ACS_HSE_SE_2024\ACS_IHW_2'
RARS_JAR_PATH = r'D:\Programms\RARS\rars1_5.jar'
ASSEMBLY_FILES = ['main.asm', 'input.asm', 'bisect.asm']
BOUNDS = (1e-8, 1e-3)


def get_asm_res(tolerance):
    run_asm = f'java -jar {RARS_JAR_PATH} {" ".join([os.path.join(PROJECT_PATH, filename) for filename in ASSEMBLY_FILES])}'
    result = subprocess.run(
        run_asm,
        input=f'{tolerance}\n',
        capture_output=True,
        text=True
    )
    return float(result.stdout.split(' ')[-1])


if __name__ == '__main__':
    errors = []

    for eps in tqdm(np.arange(BOUNDS[0], BOUNDS[1], (BOUNDS[1] - BOUNDS[0]) / 30), desc='Testing 30 tolerance values '
                                                                                        'as arithmetic progression'):
        asm_value = get_asm_res(eps)
        py_value = find_root(f, eps)
        if abs(asm_value - py_value) > eps:
            errors.append(eps)

    for eps in tqdm(np.random.uniform(BOUNDS[0], BOUNDS[1], 30), desc='Testing 30 random tolerance values'):
        asm_value = get_asm_res(eps)
        py_value = find_root(f, eps)
        if abs(asm_value - py_value) > eps:
            errors.append(eps)

    if len(errors) > 0:
        print(f'[!] Mistakes on tolerance values: {errors}')
    else:
        print(f'[+] All tests passed correctly.')
