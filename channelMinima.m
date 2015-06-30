function phi = channelMinima(N, M, Lambda)

range = (0:N-1)';

phi = 2*pi * (range .* (range <= M) + (Lambda*(range-M) + M) .* (range > M));

end
