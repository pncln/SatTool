function d = distanceFcn(track, truth)
    estimate = track.State([1 3 5 2 4 6]);
    true = [truth.Position(:) ; truth.Velocity(:)];
    cov = track.StateCovariance([1 3 5 2 4 6], [1 3 5 2 4 6]);
    d = (estimate - true)' / cov * (estimate - true);
end