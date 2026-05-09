function [cost_ratios, mean_performance_ratio, mean_regret] = ...
    run_experiment_cost_asymmetry(hss, n, mu, sigma)

% Cases for each regime:
% cu < co, cu = co, cu > co

p_values = [11 15 20 15 20 20];
c_values = [10 10 10 10 10 10];
r_values = [0  0  0  8  8  9];;

cost_ratios = zeros(size(p_values));
mean_performance_ratio = zeros(size(p_values));
mean_regret = zeros(size(p_values));

for i = 1:length(p_values)

    p = p_values(i);
    c = c_values(i);
    r = r_values(i);

    cu = p - c; % cost of underage
    co = c - r; % cost of overage

    cost_ratios(i) = cu / co;

    oq = optimal_order_quantity(mu, sigma, p, c, r);
    oep = expected_profit(oq, mu, sigma, p, c, r);

    performance_ratios = zeros(n, 1);
    regrets = zeros(n, 1);

    for k = 1:n

        demand_sample = mu + sigma * randn(hss, 1);

        estimated_mu = mean(demand_sample);
        estimated_sigma = std(demand_sample, 1);

        estimated_order_quantity = optimal_order_quantity( ...
            estimated_mu, estimated_sigma, p, c, r);

        estimated_decision_profit = expected_profit( ...
            estimated_order_quantity, mu, sigma, p, c, r);

        performance_ratios(k) = estimated_decision_profit / oep;
        regrets(k) = oep - estimated_decision_profit;

    end

    mean_performance_ratio(i) = mean(performance_ratios);
    mean_regret(i) = mean(regrets);

end

end