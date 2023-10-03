#EJERCICIO 2 SEMANA 1 METODOS DE SIMULACION

#parameters of the system
a=0
b=1
c=1
Exact_Value=pi/4

global Porcent_1=0
global Porcent_2=0
global Porcent_3=0





#function described in the exercise
function f(x)
    f=sqrt(1-x^2)
end


#Hit and miss method
for j in 1:10000
    Hits_inside=0
    for i in 1:100
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
    p=Hits_inside/100
    r=(b-a)*c*p
    s=sqrt((1-p)/(100*p))*r
    #Between 3s & 2s
    if -3*s<Exact_Value-r<3*s
        global Porcent_3=Porcent_3+ 1
    end
    #Between 2s & s 
    if -2*s<=Exact_Value-r<2*s
        global Porcent_2=Porcent_2+ 1
    end
    #Between s & 0
    if -s<=Exact_Value-r<s
        global Porcent_1=Porcent_1+ 1
    end 
end 

return(Porcent_3*100/10000, Porcent_2*100/10000, Porcent_1*100/10000)

