using Random
using Plots
using DelimitedFiles


#parameters of the system

a=0
b=1
c=1
p_Values=[]
r_Values=[]
s_Values=[]
sqrt_M=[]

#function
function f(x)
    f=sqrt(1-x^2)
end

#array of the number of tries
M=[10,100,1000,10000,100000,1000000,10000000]

#Hit and miss method
for j in M
    Hits_inside=0
    for i in 1:j 
        #random value for x between 0 & 1
        u=rand()
        #random value for y between 0 & 1
        v=rand()
        #Apply the condition g(x)>y to see if it's inside or outside
        if f(a+(b-a)*u)>c*v
            Hits_inside+=1
        end
    end
    #new values for de calculated variables
    p=Hits_inside/j
    r=(b-a)*c*p
    s=sqrt(p*(1-p)/j)*c*(b-a)
    # arrays with the calculated variables for different values of M
    push!(p_Values, p)
    push!(r_Values, r)
    push!(s_Values, s)
end 
########################

Matriz=[M p_Values r_Values s_Values]

open("Ejercicio1.txt", "w")
writedlm("Ejercicio1.txt", Matriz)


#plot of sigma against M #####
x=Matriz[:,1]
y=Matriz[:,4]
scatter(x , y , xlabel="M" , ylabel="σ" , label="Experimental results" , xaxis=:log, grid=false )

f(x_exact)=1/sqrt(x_exact)
x_exact=range(10, stop=10000000,length=10000000)
y_exact=f.(x_exact)


plot!(x_exact, y_exact , label="1/√M")

savefig("Ejercicio1.png")
#############################



#Linear regression
function Linear_regression(x_array, y_array)
    sum_x=0
    sum_y=0
    sum_xy=0
    sum_x_square=0
    n=0
    for i in 1:length(x_array)
       sum_x+=x_array[i] 
       sum_y+=y_array[i]
       sum_xy+=x_array[i]*y_array[i]
       sum_x_square+=x_array[i]^2
       n+=1
    end
    a=(sum_y*sum_x_square-sum_x*sum_xy)/(n*sum_x_square-sum_x^2)
    b=(n*sum_xy-sum_x*sum_y)/(n*sum_x_square-sum_x^2)
    return(a,b)
end
###################


#Vector 1/sqrt(M)
for i in 1:length(M)
    valor=1/sqrt(M[i])
    push!(sqrt_M, valor)
end

x_new=sqrt_M
##################


###plot sigma against 1/sqrt(M)
scatter(x_new , y , xlabel="1/√M" , ylabel="σ", label="", grid=false)

b_regression,a_regression=Linear_regression(x_new,s_Values)
x_continue=range(0, stop=0.4,length=100)
g(x_continue)=a_regression*x_continue+ b_regression
y_continue=g.(x_continue)

plot!(x_continue, y_continue, label="linear regression", grid=false)

savefig("Ejercicio1_Linear_Regression.png")
##############################




#Plot real error vs M
Exact_Value=pi/4

Difference=broadcast(abs, Exact_Value.-r_Values)

scatter(x, Difference, xlabel="M" , ylabel="Absolute Value", xaxis=:log , yaxis=:log, label="", grid=false)

savefig("Ejercicio1_Absolute_Difference.png")