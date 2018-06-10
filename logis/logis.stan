data{
    int<lower=1> N;
    int<lower=1> N_encuestadora;
    int id[N];
    int n[N];
    int encuestadora[N];
}
parameters{
    vector[N_encuestadora] a;
    real<lower=0> s;
}
model{
    vector[N] p;
    s ~ cauchy( 0 , 5 );
    a ~ normal( 0 , 10 );
    a ~ normal( a , s );
    for ( i in 1:N ) {
        p[i] = a[encuestadora[i]];
    }
    id ~ binomial_logit( n , p );
}
generated quantities{
    vector[N] p;
    real dev;
    dev = 0;
    for ( i in 1:N ) {
        p[i] = a[encuestadora[i]];
    }
    dev = dev + (-2)*binomial_logit_lpmf( id | n , p );
}
