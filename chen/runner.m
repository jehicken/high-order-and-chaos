%% Define infinite time average value for Chen system

Z_true = 23.826179425264577;

%% Import all solution data

% Ensure NewtonCotes rules and importer function are on MATLAB path
path(path, replace(pwd, 'chen', 'NewtonCotes'))
path(path, replace(pwd, 'chen', 'utils'))

% GLRK data
z_GLRK_0_0025 = solution_importer('Simulated Solutions\GLRK(4)_u_0.0025.txt');
z_GLRK_0_005 = solution_importer('Simulated Solutions\GLRK(4)_u_0.005.txt');
z_GLRK_0_01 = solution_importer('Simulated Solutions\GLRK(4)_u_0.01.txt');
z_GLRK_0_02 = solution_importer('Simulated Solutions\GLRK(4)_u_0.02.txt');
z_GLRK_0_04 = solution_importer('Simulated Solutions\GLRK(4)_u_0.04.txt');

% RK4 data
z_RK4_0_0025 = solution_importer('Simulated Solutions\RK4_u_0.0025.txt');
z_RK4_0_005 = solution_importer('Simulated Solutions\RK4_u_0.005.txt');
z_RK4_0_01 = solution_importer('Simulated Solutions\RK4_u_0.01.txt');
z_RK4_0_02 = solution_importer('Simulated Solutions\RK4_u_0.02.txt');
z_RK4_0_04 = solution_importer('Simulated Solutions\RK4_u_0.04.txt');

% Heun's method data
z_Heun_0_0025 = solution_importer('Simulated Solutions\Heun_u_0.0025.txt');
z_Heun_0_005 = solution_importer('Simulated Solutions\Heun_u_0.005.txt');
z_Heun_0_01 = solution_importer('Simulated Solutions\Heun_u_0.01.txt');
z_Heun_0_02 = solution_importer('Simulated Solutions\Heun_u_0.02.txt');

%% Run the method comparisons and build the stat matrices.

run('..\utils\method_comparisons_0_04_chen.m')
run('..\utils\method_comparisons_0_02.m')
run('..\utils\method_comparisons_0_01.m')
run('..\utils\method_comparisons_0_005.m')
run('..\utils\method_comparisons_0_0025.m')
run('stats_matrix_chen.m')
