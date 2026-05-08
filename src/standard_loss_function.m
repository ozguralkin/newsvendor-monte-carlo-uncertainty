function loss = standard_loss_function(z)

loss = normpdf(z) - z .* (1 - normcdf(z));

end