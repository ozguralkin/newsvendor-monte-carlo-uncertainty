function [mean_performance_ratio, mean_regret] = run_experiment_salvage_uncertainty( ...
    se, hss, n, mu, sigma, p, c, r)

q = optimal_order_quantity(mu, sigma, p, c, r); % q = optimal order quantity

oep = expected_profit(q, mu, sigma, p, c, r); %oep = optimal expected profit

mean_performance_ratio = zeros(size(se));
mean_regret = zeros(size(se));

for i = 1:length(se)

    sei = se(i);

    performance_ratios = zeros(n, 1);
    regrets = zeros(n, 1);

    for k = 1:n

        demand_sample = mu + sigma * randn(hss, 1);

        estimated_mu = mean(demand_sample);
        estimated_sigma = std(demand_sample, 1);

        estimated_r = r + sei * randn;
        estimated_r = max(0, min(estimated_r, c - 0.01));

        estimated_q = optimal_order_quantity(estimated_mu, estimated_sigma, p, c, estimated_r);

        estimated_decision_profit = expected_profit(estimated_q, mu, sigma, p, c, r);

        performance_ratios(k) = estimated_decision_profit / oep;
        regrets(k) = oep - estimated_decision_profit;

    end

    mean_performance_ratio(i) = mean(performance_ratios);
    mean_regret(i) = mean(regrets);

end

end