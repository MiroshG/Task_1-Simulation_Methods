using Random
using DelimitedFiles

Dimensions_array=[1,2,3,5,10]
M=10000000
a=-1
b=1
c=1
p_Values=[]
r_Values=[]
s_Values=[]

r_Sampling=[]
s_Sampling=[]
Simpson_array=[]

function g(x)
    # exponential of the sum of -xn^2 times the square of the cos (x1*x2+x2*x3+...+xn*x1)
    exponential=exp(-sum(x.^2))
    argument_cos=x[1]*last(x)
    for i in 1:length(x)-1
        argument_cos+=x[i]*x[i+1]
    end
    return exponential*cos(argument_cos)
end



# Hit and Miss ###############################
Hit_and_Miss_Time = @elapsed begin
    for n in Dimensions_array
        Hits_inside=0
        for i in 1:M
            if g(a.+(b-a).*rand(Float64,n))>c.*rand()
                Hits_inside+=1
            end
        end
        p=Hits_inside/M
        mean=p * ((b-a)^n*c)
        error=sqrt(p*(1-p)/M)*c*(b-a)^n
        push!(p_Values, p)
        push!(r_Values, mean)
        push!(s_Values, error)
    end
end


# Uniform Sampling #################################
Uniform_Sampling_Time = @elapsed begin
    for n in Dimensions_array
        Mean=0
        Error=0
        for i in 1:M
            g0 = g(a .+ (b-a) .* rand(Float64,n))
            Mean += g0
            Error += g0^2
        end
        Mean = Mean/M
        Error = sqrt((Error/M-Mean^2)/M)
        Mean = Mean*(b-a)^n 
        Error = (b-a)^n *Error
        push!(s_Sampling, Error)
        push!(r_Sampling, Mean)
    end
end


# Simpson ###########################

# Function for the recursion ####
function join(a,b) 
    c = copy(a)
    return append!(c, b)
end

#################################

function simpson(g, arglist, n, i=0)
    if i<n
        h = (b-a)/6
        one = simpson(  g, join(arglist, a), n , i+1)
        two = 4*simpson(g, join(arglist, (a+b)/2), n ,  i+1)
        tre = simpson(  g, join(arglist, b), n ,  i+1)
        h*(one + two + tre)
    else
        g(arglist)
    end
end

Simpson_Time = @elapsed begin
    for j in Dimensions_array
        push!(Simpson_array,simpson(g, [], j))
    end
end

#################################################


open("Exercise_19-Hit_and_Miss.txt", "w")
writedlm("Exercise_19-Hit_and_Miss.txt", [Dimensions_array p_Values r_Values s_Values])

open("Exercise_19-Uniform_Sampling.txt", "w")
writedlm("Exercise_19-Uniform_Sampling.txt", [Dimensions_array  r_Sampling s_Sampling])

open("Exercise_19-Simpson.txt", "w")
writedlm("Exercise_19-Simpson.txt", [Dimensions_array  Simpson_array])


# Time to compute for the different methods ################################

println("Hit and miss took $Hit_and_Miss_Time seconds to compute all dimensions.")
println("Uniform Sampling took $Uniform_Sampling_Time seconds to compute all dimensions.")
println("Simpson took $Simpson_Time seconds to compute all dimensions.")