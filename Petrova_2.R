#�������� ������ ������������� �������� ��������� ������� ������� ������� ����� ���� �� ������ 2013 ���� 
#�� ������ ��������� ������� ������������ ��������� 
# ��� ������ ������ ����� ����������� ���������� DOY - ���� ���� (1 ������ - DOY = 1) 

#���������� tidyverse 
library(tidyverse) 
#������ ������ �� �����, ���������� ������ ������, �������� ��������� 'NA', ������ � ��������������� ��������� �������� �� NA, ���������� ������ � "[" 
data = read_csv("eddypro.csv", skip = 1, na =c("","NA","-9999","-9999.0"), comment=c("[")) 
data = data[-1,] 
#������� �������� ������� 
data = data[, c(-1, -3, -9, -12, -15, -18, -21, -30, -35, -63 , -70, -88:-99) ] 
#����������� ��������� �������� � ��������� 
data = data %>% mutate_if(is.character, factor) 
#�������� ������������� ����� ������� 
names(data) = names(data) %>% str_replace_all("[!]","_emph_") %>% 
  str_replace_all("[?]","_quest_") %>% 
  str_replace_all("[*]","_star_") %>% 
  str_replace_all("[+]","_plus_") %>% 
  str_replace_all("[-]","_minus_") %>% 
  str_replace_all("[@]","_at_") %>% 
  str_replace_all("[$]","_dollar_") %>% 
  str_replace_all("[#]","_hash_") %>% 
  str_replace_all("[/]","_div_") %>% 
  str_replace_all("[%]","_perc_") %>% 
  str_replace_all("[&]","_amp_") %>% 
  str_replace_all("[\\^]","_power_") %>% 
  str_replace_all("[()]","_") 
#���������, ��� ���������� 
glimpse(data) 
#������� ��� ������ ������� daytime 
data$daytime = as.logical(data$daytime) 
#������� ������ ������ �� ������� ���������� 2013 ����: 
data = data[data$daytime == TRUE, c(1:ncol(data))] 
#������� ��� ���������� ���� numeric 
data_numeric = data[,sapply(data,is.numeric) ] 
#��� ��������� ����������: 
data_non_numeric = data[,!sapply(data,is.numeric) ] 
# �������� ������� ��� ��������������� ������� � ����������� �� � �������, ������ ������ ������� (������ ����� ����) 
cor_td = cor(drop_na(data_numeric)) %>% as.data.frame %>% select(h2o_flux) 
#������� ����� ���������� (�����) � ������������� ������������ ������ 0.1 
vars = row.names(cor_td)[cor_td$h2o_flux^2 > .1] %>% na.exclude; vars 
#������� ���������� �� ������� � ���� �������: 
formula = as.formula(paste("h2o_flux~", paste(vars,collapse = "+"), sep="")); formula 
#�������� ��������� � ����������� �������: 
row_numbers = 1:length(data$date) 
teach = sample(row_numbers, floor(length(data$date)*.7)) 
test = row_numbers[-teach] 
#���������������� ����������: 
teaching_tbl_unq = data[teach,] 
testing_tbl_unq = data[test,] 
# ������ 1 
#������� ������ �������� ��������� 
model1 = lm(formula, data = data);model 
#������������ 
coef(model1) 
#������� 
resid(model1) 
#������������� �������� 
confint(model1) 
#P-�������� �� ������ 
summary(model1) 
#������������� ������ 
anova(model1) 
#����������� ������������� ������: 
plot(model1) 

# ������ 2 
formula = as.formula(paste("h2o_flux~", "(", paste(vars,collapse = "+"), ")^2", sep="", collapse = NULL));formula 
#������� ������ �������� ��������� 
model2 = lm(formula, data = data);model 
#������������ 
coef(model2) 
#������� 
resid(model2) 
#������������� �������� 
confint(model2) 
#P-�������� �� ������ 
summary(model2) 
#������������� ������ 
anova(model2) 
#����������� ������������� ������: 


# ������ 3 
formula2 = h2o_flux~rand_err_LE+LE+rand_err_LE+rand_err_h2o_flux+h2o_time_lag+sonic_temperature+air_temperature+air_density+air_molar_volume+es+RH+VPD+u_star_+TKE+un_LE+un_h2o_flux+w_div_h2o_cov 
#������� ������ �������� ��������� 
model3 = lm(formula2, data = data);model2 
#������������ 
coef(model3) 
#������� 
resid(model3) 
#������������� �������� 
confint(model3) 
#P-�������� �� ������ 
summary(model3) 
#������������� ������ 
anova(model3) 
#����������� ������������� ������: 

# ������ 4 
formula3 = h2o_flux~LE+rand_err_LE+air_density+air_molar_volume+es+RH+VPD+un_LE+un_h2o_flux+w_div_h2o_cov 
#������� ������ �������� ��������� 
model4 = lm(formula3, data = data);model3 
#������������ 
coef(model4) 
#������� 
resid(model4) 
#������������� �������� 
confint(model4) 
#P-�������� �� ������ 
summary(model4) 
#������������� ������ 
anova(model4) 
#����������� ������������� ������: 

formula4 = h2o_flux~VPD+LE 
model5= lm(formula4,data=data) 
summary(model5)
