function q = optimal_order_quantity(mu, sigma, p, c, r)
    
% mu= mean, sigma=standard dev., p=selling price, c=purchasing price,
% r=return price

cu = p - c;
co = c - r;

%cu=cost of underage, co = cost of overage

or = cu / (cu + co);

%q = optimal ratio

q = mu + sigma * norminv(or);

%orq = optimal order quantity

q = max(q,0);

end
