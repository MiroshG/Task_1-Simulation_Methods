#Importance Sampling Method

function g(x)
    sqrt(x)*cos(x)
end

function Importance_Sampling_Method(M)
    r=0
    s=0
    for i in 1:M
        g0=g(-log(rand()))
        r+=g0
        s+=g0^2
    end
    r=r/M
    s=sqrt((s/M-r^2)/M)
    return(r, s)
end
@time println(Importance_Sampling_Method(10000000))

