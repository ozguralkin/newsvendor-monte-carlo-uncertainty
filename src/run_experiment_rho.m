function [mean_performance_ratio, mean_regret] = run_experiment_rho(rho, hss, n, mu, p, c, r)

mean_performance_ratio = zeros(size(rho));
mean_regret = zeros(size(rho));

for i = 1:length(rho)

    rhoi = rho(i);
    true_sigma = rhoi * mu;

    oq = optimal_order_quantity(mu, true_sigma, p, c, r);

    %oq = optimal order quantity

    oep = expected_profit(oq, mu, true_sigma, p, c, r);

    %oep = optimal expected profit

    performance_ratios = zeros(n, 1);
    
    regrets = zeros(n, 1);

    for k = 1:n

        demand_sample = mu + true_sigma * randn(hss, 1);

        estimated_mean_demand = mean(demand_sample);
        estimated_demand_sigma = std(demand_sample, 1);

        estimated_order_quantity = optimal_order_quantity(estimated_mean_demand, estimated_demand_sigma, p, c, r);

        estimated_decision_profit = expected_profit(estimated_order_quantity, mu, true_sigma, p, c, r);

        performance_ratios(k) = estimated_decision_profit / oep;
        regrets(k) = oep - estimated_decision_profit;

    end

    mean_performance_ratio(i) = mean(performance_ratios);
    mean_regret(i) = mean(regrets);

end

end