function [cost_ratios, mean_performance_ratio, mean_regret] = run_experiment_cost_asymmetry(sp, hss, n, mu, sigma, p, c)

mean_performance_ratio = zeros(size(sp));
mean_regret = zeros(size(sp));
cost_ratios = zeros(size(sp));

for i = 1:length(sp)

    r = sp(i);

    % r = salvage price

    cu = p - c; %cost of underage
    co = c - r; %cost of overgae

    cost_ratios(i) = cu / co;

    oq = optimal_order_quantity(mu, sigma, p, c, r); %oq = optimal order quantity

    oep = expected_profit(oq, mu, sigma, p, c, r); %oep = optimal expected profit

    performance_ratios = zeros(n, 1);
    regrets = zeros(n, 1);

    for k = 1:n

        demand_sample = mu + sigma * randn(hss, 1);

        estimated_mu = mean(demand_sample);
        estimated_sigma = std(demand_sample, 1);

        estimated_order_quantity = optimal_order_quantity(estimated_mu, estimated_sigma, p, c, r);

        estimated_decision_profit = expected_profit(estimated_order_quantity, mu, sigma, p, c, r);

        performance_ratios(k) = estimated_decision_profit / oep;
        regrets(k) = oep - estimated_decision_profit;

    end

    mean_performance_ratio(i) = mean(performance_ratios);
    mean_regret(i) = mean(regrets);

end

end