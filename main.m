%% Assignment 1 - Newsvendor Monte Carlo Uncertainty Analysis

clear; clc; close all;
addpath('src');

rng(348306);

%% Base parameters

mu = 100;
sigma = 20;

p = 20;
c = 10;
r = 4;

n = 10000; %number of simulations

q = optimal_order_quantity(mu, sigma, p, c, r);

ep = expected_profit(q, mu, sigma, p, c, r);

fprintf("True optimal order quantity q* = %.4f\n", q);
fprintf("True optimal expected profit = %.4f\n\n", ep);

%% Experiment 1: Sample size

ss = [5 10 20 50 100 250 500 1000]; %sample sizes

[mean_ratio_sample, mean_regret_sample] = run_experiment_sample_size(ss, n, mu, sigma, p, c, r);

figure;
plot(ss, mean_ratio_sample, '-o', 'LineWidth', 1.5);
xlabel('Sample size n');
ylabel('Mean performance ratio');
title('Effect of sample size on Newsvendor performance');
grid on;
saveas(gcf, 'results/figures/sample_size_ratio.png');

figure;
plot(ss, mean_regret_sample, '-o', 'LineWidth', 1.5);
xlabel('Sample size n');
ylabel('Mean regret');
title('Effect of sample size on expected regret');
grid on;
saveas(gcf, 'results/figures/sample_size_regret.png');

%% Experiment 2: Salvage price uncertainty

se = [0 0.5 1 2 3 4 5]; %salvage error
hss = 50; %historical sample size

[mean_ratio_salvage, mean_regret_salvage] = run_experiment_salvage_uncertainty( ...
    se, hss, n, mu, sigma, p, c, r);

figure;
plot(se, mean_ratio_salvage, '-o', 'LineWidth', 1.5);
xlabel('Standard deviation of salvage price forecast error');
ylabel('Mean performance ratio');
title('Effect of salvage price uncertainty');
grid on;
saveas(gcf, 'results/figures/salvage_uncertainty_ratio.png');

figure;
plot(se, mean_regret_salvage, '-o', 'LineWidth', 1.5);
xlabel('Standard deviation of salvage price forecast error');
ylabel('Mean regret');
title('Regret caused by salvage price uncertainty');
grid on;
saveas(gcf, 'results/figures/salvage_uncertainty_regret.png');

%% Experiment 3: Cost asymmetry

sp = [0 2 4 6 8 9];

%different salvage prices

[cost_ratios, mean_ratio_cost, mean_regret_cost] = run_experiment_cost_asymmetry(sp, hss, n, mu, sigma, p, c);

figure;
plot(cost_ratios, mean_ratio_cost, '-o', 'LineWidth', 1.5);
xlabel('Underage / overage cost ratio c_u / c_o');
ylabel('Mean performance ratio');
title('Effect of cost asymmetry');
grid on;
saveas(gcf, 'results/figures/cost_asymmetry_ratio.png');

figure;
plot(cost_ratios, mean_regret_cost, '-o', 'LineWidth', 1.5);
xlabel('Underage / overage cost ratio c_u / c_o');
ylabel('Mean regret');
title('Expected regret under different cost ratios');
grid on;
saveas(gcf, 'results/figures/cost_asymmetry_regret.png');

%% Experiment 4: Coefficient of variation

rho = [0.05 0.10 0.15 0.20 0.30 0.40];

% rho = coefficient of variation

[mean_ratio_rho, mean_regret_rho] = run_experiment_rho( ...
    rho, hss, n, mu, p, c, r);

figure;
plot(rho, mean_ratio_rho, '-o', 'LineWidth', 1.5);
xlabel('Coefficient of variation \sigma / \mu');
ylabel('Mean performance ratio');
title('Effect of demand variability');
grid on;
saveas(gcf, 'results/figures/cv_ratio.png');

figure;
plot(rho, mean_regret_rho, '-o', 'LineWidth', 1.5);
xlabel('Coefficient of variation \sigma / \mu');
ylabel('Mean regret');
title('Expected regret under different demand variability levels');
grid on;
saveas(gcf, 'results/figures/cv_regret.png');

%% Summary tables

T_sample = table(ss', mean_ratio_sample', mean_regret_sample', ...
    'VariableNames', {'SampleSize', 'MeanPerformanceRatio', 'MeanRegret'});

T_salvage = table(se', mean_ratio_salvage', mean_regret_salvage', ...
    'VariableNames', {'SalvageErrorStd', 'MeanPerformanceRatio', 'MeanRegret'});

T_cv = table(rho', mean_ratio_rho', mean_regret_rho', ...
    'VariableNames', {'CoefficientOfVariation', 'MeanPerformanceRatio', 'MeanRegret'});

writetable(T_sample, 'results/tables/sample_size_results.csv');
writetable(T_salvage, 'results/tables/salvage_uncertainty_results.csv');
writetable(T_cv, 'results/tables/cv_results.csv');

disp(T_sample);
disp(T_salvage);
disp(T_cv);
