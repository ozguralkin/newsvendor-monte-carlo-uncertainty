function [mean_performance_ratio, mean_regret] = run_experiment_sample_size(ss, n, mu, sigma, p, c, r)

q = optimal_order_quantity(mu, sigma, p, c, r);

oep = expected_profit(q, mu, sigma, p, c, r);

%oep = optimal expected profit

mean_performance_ratio = zeros(size(ss));
mean_regret = zeros(size(ss));

for i = 1:length(ss)

    sample_size = ss(i);

    performance_ratios = zeros(n, 1);
    regrets = zeros(n, 1);

    for k = 1:n

        demand_sample = mu + sigma * randn(sample_size, 1);

        estimated_mean_demand = mean(demand_sample);
        estimated_sigma = std(demand_sample, 1);

        estimated_order_quantity = optimal_order_quantity(estimated_mean_demand, estimated_sigma, p, c, r);

        estimated_decision_profit = expected_profit(estimated_order_quantity, mu, sigma, p, c, r);

        performance_ratios(k) = estimated_decision_profit / oep;
        regrets(k) = oep - estimated_decision_profit;

    end

    mean_performance_ratio(i) = mean(performance_ratios);
    mean_regret(i) = mean(regrets);

end

end