%% Define infinite time average value for Lorenz system

digitsOld = digits(430);
Z_true = sym("23.48468206951560755245057102025885979019964736765101924707073717557587258424199920886343339296252912951352491012574579728837492837908146796544143984717970678004311135572490748065191862686863343643256426105086074910125752532750449061231599561663829395691169702709602537689153890023399543833773688068719317285034023205710501713870759360345043011808489315996709079430022133849451570275830309192590323130272650067634773054825306185773");

%% Import all solution data

% Ensure NewtonCotes rules and importer function are on MATLAB path
path(path, replace(pwd, 'lorenz', 'NewtonCotes'))
path(path, replace(pwd, 'lorenz', 'utils'))

% GLRK data
z_GLRK_0_0025 = solution_importer('Simulated Solutions\GLRK(4)_u_0.0025.txt');
z_GLRK_0_005 = solution_importer('Simulated Solutions\GLRK(4)_u_0.005.txt');
z_GLRK_0_01 = solution_importer('Simulated Solutions\GLRK(4)_u_0.01.txt');
z_GLRK_0_02 = solution_importer('Simulated Solutions\GLRK(4)_u_0.02.txt');
z_GLRK_0_04 = solution_importer('Simulated Solutions\GLRK(4)_u_0.04.txt');
z_GLRK_0_08 = solution_importer('Simulated Solutions\GLRK(4)_u_0.08.txt');
z_GLRK_0_16 = solution_importer('Simulated Solutions\GLRK(4)_u_0.16.txt');
z_GLRK_0_32 = solution_importer('Simulated Solutions\GLRK(4)_u_0.32.txt');

% RK4 data
z_RK4_0_0025 = solution_importer('Simulated Solutions\RK4_u_0.0025.txt');
z_RK4_0_005 = solution_importer('Simulated Solutions\RK4_u_0.005.txt');
z_RK4_0_01 = solution_importer('Simulated Solutions\RK4_u_0.01.txt');
z_RK4_0_02 = solution_importer('Simulated Solutions\RK4_u_0.02.txt');
z_RK4_0_04 = solution_importer('Simulated Solutions\RK4_u_0.04.txt');
z_RK4_0_08 = solution_importer('Simulated Solutions\RK4_u_0.08.txt');
z_RK4_0_16 = solution_importer('Simulated Solutions\RK4_u_0.16.txt');

% Heun's method data
z_Heun_0_0025 = solution_importer('Simulated Solutions\Heun_u_0.0025.txt');
z_Heun_0_005 = solution_importer('Simulated Solutions\Heun_u_0.005.txt');
z_Heun_0_01 = solution_importer('Simulated Solutions\Heun_u_0.01.txt');
z_Heun_0_02 = solution_importer('Simulated Solutions\Heun_u_0.02.txt');
z_Heun_0_04 = solution_importer('Simulated Solutions\Heun_u_0.04.txt');

%% Run the method comparisons and build the stat matrices.

run('..\utils\method_comparisons_0_32.m')
run('..\utils\method_comparisons_0_16.m')
run('..\utils\method_comparisons_0_08.m')
run('..\utils\method_comparisons_0_04_lorenz.m')
run('..\utils\method_comparisons_0_02.m')
run('..\utils\method_comparisons_0_01.m')
run('..\utils\method_comparisons_0_005.m')
run('..\utils\method_comparisons_0_0025.m')
run('stats_matrix_lorenz.m')

%% Cleanup
digits(digitsOld);
clear digitsOld