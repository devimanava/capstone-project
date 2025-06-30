/* Preparation steps:
a) Create a GCP project if not already present
b) Create a Google Cloud Storage bucket within the GCP project and upload the files nutrient.csv, branded_food.csv, food_nutrient.csv to the bucket
c) Within the desired GCP project, create a BigQuery dataset called 'food_capstone_project'
d) Under the BigQuery dataset created, create a table and choose 'Google Cloud Storage' under Create Table option. Select the file branded_food.csv and name the table being created as 'fda_branded_food_data'
e) Under the BigQuery dataset created, create a table and choose 'Google Cloud Storage' under Create Table option. Select the file food_nutrient.csv and name the table being created as 'fda_food_nutrient'
f) Under the BigQuery dataset created, create a table and choose 'Google Cloud Storage' under Create Table option. Select the file nutrient.csv and name the table being created as 'fda_nutrient'
After the above steps are complete, there would be 3 tables created from steps (d) to (f) in the BigQuery dataset 'food_capstone_project'

The below query can now be executed to create the final dataset 'food_data_with_nutrients' which will be used for the Juypter notebook machine learning project. Replace <YOUR_PROJECT_ID> with the GCP project ID created in the first step above
*/

create or replace table `<YOUR-PROJECT-ID>.food_capstone_project.fda_food_nutrient_merged` as (
  with nutrient_data as (
select * from 
`<YOUR-PROJECT-ID>.food_capstone_project.fda_food_nutrient` a
left join food_capstone_project.fda_nutrient b
on a.nutrient_id = b.id)

select a.fdc_id,brand_name,subbrand_name,serving_size,serving_size_unit,
branded_food_category,package_weight,market_country,
nutrient_id, name as nutrient_name,
amount as nutrient_amount,unit_name as nutrient_unit_name,nutrient_nbr,
rank
from  food_capstone_project.fda_branded_food_data a
left join nutrient_data b
on a.fdc_id = CAST(b.fdc_id as STRING)
where serving_size is not null
order by 1);

create or replace table `<YOUR-PROJECT-ID>.food_capstone_project.fda_final_table` as (
select a.*,b.description as food_name
from `<YOUR-PROJECT-ID>.food_capstone_project.fda_food_nutrient_merged` a
left join `<YOUR-PROJECT-ID>.food_capstone_project.fda_food` b
on a.fdc_id = CAST(b.fdc_id as STRING));

--select * from `<YOUR-PROJECT-ID>.food_capstone_project.fda_final_table`;

create or replace table `<YOUR-PROJECT-ID>.food_capstone_project.fda_breakfast` as (
select * except (nutrient_nbr,rank,nutrient_name,nutrient_unit_name,nutrient_id),
--concat(REPLACE(REPLACE(nutrient_name," ","_"),",","_"),"_",nutrient_unit_name) as nutrient
concat(REGEXP_REPLACE(REPLACE(nutrient_name," ","_"),"[+,()]","_"),"_",nutrient_unit_name) as nutrient
from `<YOUR-PROJECT-ID>.food_capstone_project.fda_final_table`
where REGEXP_CONTAINS(lower(food_name) , "cereal|yogurt|bar|bread|muffin|bagel|waffle")
);

create or replace table `<YOUR-PROJECT-ID>.food_capstone_project.food_data_with_nutrients` as (
select fdc_id,brand_name,subbrand_name,food_name,branded_food_category,market_country,serving_size,serving_size_unit,
`Fatty_acids__total_saturated_G`,`Sugars__added_G`,`Fatty_acids__total_trans_G`,`Sodium__Na_MG`,`Thiamin_MG`,`Fiber__total_dietary_G`,`Vitamin_D__D2___D3___International_Units_IU`,`Protein_G`,`Pantothenic_acid_MG`,`Vitamin_C__total_ascorbic_acid_MG`,`Total_lipid__fat__G`,`Cholesterol_MG`,`Potassium__K_MG`,`Carbohydrate__by_difference_G`,`Total_Sugars_G`,`Calcium__Ca_MG`,`Iron__Fe_MG`,`Vitamin_B-6_MG`,`Energy_KCAL`,`Fatty_acids__total_polyunsaturated_G`,`Vitamin_A__IU_IU`,`Fatty_acids__total_monounsaturated_G`,`Folic_acid_UG`,`Vitamin_E__alpha-tocopherol__MG`,`Selenium__Se_UG`,`Manganese__Mn_MG`,`Niacin_MG`,`Phosphorus__P_MG`,`Zinc__Zn_MG`,`Riboflavin_MG`,`Folate__total_UG`,`Fiber__soluble_G`,`Vitamin_E_MG_ATE`,`Magnesium__Mg_MG`,`Vitamin_K__phylloquinone__UG`,`Vitamin_B-12_UG`,`Total_sugar_alcohols_G`,`Copper__Cu_MG`,`Carbohydrate__other_G`,`Fiber__insoluble_G`,`Iodine__I_UG`,`Water_G`,`Vitamin_E__label_entry_primarily__IU`,`Starch_G`,`Ash_G`,`Folate__DFE_UG`,`Molybdenum__Mo_UG`,`Chromium__Cr_UG`,`Biotin_UG`,`Energy_kJ`,`Chlorine__Cl_MG`,`Valine_G`,`Choline__total_MG`,`Vitamin_D__D2___D3__UG`,`Vitamin_A_UG`,`Vitamin_E_MG`,`Vitamin_A__RAE_UG`,`Caffeine_MG`,`Glycine_G`,`Lysine_G`,`Cystine_G`,`Isoleucine_G`,`Sugars__Total_G`,`Vitamin_D3__cholecalciferol__UG`,`Fluoride__F_UG`,`Alanine_G`,`Tryptophan_G`,`Methionine_G`,`Aspartic_acid_G`,`Leucine_G`,`Phenylalanine_G`,`Lactose_G`,`Glutamic_acid_G`,`Xylitol_G`,`Tyrosine_G`,`Histidine_G`,`Arginine_G`,`Serine_G`,`Threonine_G`,`Proline_G`,`Alcohol__ethyl_G`
from `<YOUR-PROJECT-ID>.food_capstone_project.fda_breakfast`
PIVOT(SUM(nutrient_amount) FOR nutrient in ("Fatty_acids__total_saturated_G","Sugars__added_G","Fatty_acids__total_trans_G","Sodium__Na_MG","Thiamin_MG","Fiber__total_dietary_G","Vitamin_D__D2___D3___International_Units_IU","Protein_G","Pantothenic_acid_MG","Vitamin_C__total_ascorbic_acid_MG","Total_lipid__fat__G","Cholesterol_MG","Potassium__K_MG","Carbohydrate__by_difference_G","Total_Sugars_G","Calcium__Ca_MG","Iron__Fe_MG","Vitamin_B-6_MG","Energy_KCAL","Fatty_acids__total_polyunsaturated_G","Vitamin_A__IU_IU","Fatty_acids__total_monounsaturated_G","Folic_acid_UG","Vitamin_E__alpha-tocopherol__MG","Selenium__Se_UG","Manganese__Mn_MG","Niacin_MG","Phosphorus__P_MG","Zinc__Zn_MG","Riboflavin_MG","Folate__total_UG","Fiber__soluble_G","Vitamin_E_MG_ATE","Magnesium__Mg_MG","Vitamin_K__phylloquinone__UG","Vitamin_B-12_UG","Total_sugar_alcohols_G","Copper__Cu_MG","Carbohydrate__other_G","Fiber__insoluble_G","Iodine__I_UG","Water_G","Vitamin_E__label_entry_primarily__IU","Starch_G","Ash_G","Folate__DFE_UG","Molybdenum__Mo_UG","Chromium__Cr_UG","Biotin_UG","Energy_kJ","Chlorine__Cl_MG","Valine_G","Choline__total_MG","Vitamin_D__D2___D3__UG","Vitamin_A_UG","Vitamin_E_MG","Vitamin_A__RAE_UG","Caffeine_MG","Glycine_G","Lysine_G","Cystine_G","Isoleucine_G","Sugars__Total_G","Vitamin_D3__cholecalciferol__UG","Fluoride__F_UG","Alanine_G","Tryptophan_G","Methionine_G","Aspartic_acid_G","Leucine_G","Phenylalanine_G","Lactose_G","Glutamic_acid_G","Xylitol_G","Tyrosine_G","Histidine_G","Arginine_G","Serine_G","Threonine_G","Proline_G","Alcohol__ethyl_G")
)
);


select * from `<YOUR-PROJECT-ID>.food_capstone_project.food_data_with_nutrients` LIMIT 100;

