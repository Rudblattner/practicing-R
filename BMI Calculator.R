weight = as.numeric(readline(prompt = "What is your weight (kilos): "))
height = as.numeric(readline(prompt = "What is your height (metres): "))
bmi = weight/(height*height)

print(paste("Your weight is ", weight, "kg, ",
            "Your height is ", height, "m, ",
            "and your BMI is ", bmi))