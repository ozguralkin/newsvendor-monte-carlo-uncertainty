function ep = expected_profit( ...
    q, mu, sigma, p, c, r)

profit_margin = p - c;
co = c - r;

z = (q - mu) / sigma;

loss = standard_loss_function(z);

ep = profit_margin * mu - co * (q - mu) - (profit_margin + co) * sigma * loss;

end