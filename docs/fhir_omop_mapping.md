[Back to main page](index.md)

# FHIR to OMOP CDM Mappings
This document shows how FHIR resources and OMOP CDM can be mapped. Please note that the work is still in progress. Your comments and feedback are greatly appreciated. Please contact us at ** if you are willing to make contributions to this project.

## FHIR DSTU2 to OMOP CDM v5
The following table shows basic mappings between FHIR DSTU2 resources and OMOP CDM v5 mapping.

| OMOP v5          |      | FHIR DSTU2             |      |
| ---------------- | ---- | ---------------------- | ---- |
| ***Table*: care_site** | **Note** | ***Resource*: Organization** | **Note** |
| care_site_id | | id | |
| care_site_name | | name | |
| place_of_service_concept_id | Vocabulary type of “Place of Service” in Concept Table. This is CMS Place of Service code. | type | |
| location_id | location Table. For updating and writing, full searching for a match must be done. | address | Complex Date Type: Address |
| | | | |
| ***Table: concept* where vocabulary_id = ‘RxNorm’** | **Note** | ***Resource*: Medication** | **Note** |
| concept_id | | id | |
| vocabulary_id, concept_name, concept_code | vocabulary: vocabulary_id is used for system URI mapping. We have manual mapping from id to FHIR system URI.  In FHIR, concept_name = display, concept code = code | code | Complex Data Type: CodeableConcept |
| concept_name, domain_id, concept_class_id, standard_concept, vocabulary_id, concept_code, valid_start_date, valid_end_date | Get string/text version of this information | narrative | Just for human readable version |
| | | | |
| ***Table*: condition_occurrence** | **Note** | ***Resource*: Condition** | **Note** |
| condition_occurrence_id | | id | |
| person_id | person Table. | patient | Resource Reference |
| visit_occurrence_id | visit_occurrence Table | encounter | Resource Reference |
| condition_type_concept_id | concept Table. Complaint <-> Patient self-reported. Others will be EHR Problem List. | category | CodeableConcept (FHIR’s) |
| provider_id | provider Table | practitioner | Resource Reference |
| condition_concept_id | concept Table. concept_code (code), concept_name (display), vocabulary_id (vocabulary table – need to convert to system URI) | code | Complex Data Type: CodeableConcept |
| condition_start_date, condition_end_date | | onset[x] | If condition_end_date is null, then onsetDateTime. If both dates are available, then onsetPeriod |
| | | verificationStatus | This is required field. We have no mapping from OMOP table. This is hardcoded to **CONFIRMED** |
| | | | |
| ***Table*: drug_exposure** where drug_type_concept_id = 38000177 or "Prescription written" | Note | ***Resource*: MedicationOrder** | Note |
| drug_exposure_id | | id | |
| person_id | person Table. | patient | Resource Reference |
| drug_exposure_start_date | | dateWritten, dispenseRequest.validityPeriod.start | |
| drug_exposure_end_date | | dispenseRequest.validityPeriod.end | |
| days_supply | | dispenseRequest.validityPeriod.end?? | validityPeriod.start+days_supploy = validityPeriod.end?? |
| drug_concept_id | concept Table. concept_code (code), concept_name (display), vocabulary_id (vocabulary table – need to convert to system URI) | medication[x], dispenseRequest.medication[x] | Complex Data Type: medicationCodeableConcept |
| refills | | dispenseRequest.numberOfRepeatsAllowed | |
| quantity | | dispenseRequest.quantity | |
| visit_occurrence_id | visit_occurrence Table | encounter | Resource Reference |
| provider_id | provider Table | prescriber | Resource (Practitioner) Reference |
| effective_drug_dose | concept table for unit | doseInstructions.doseQuantity | |
| dose_unit_concept_id | | | |
| | | | |
| ***Table*: drug_exposure where drug_type_concept_id = 38000176 or 38000175 Or "Prescription dispensed \*"** | **Note** | ***Resource*: MedicationDispense** | **Note** |
| drug_exposure_id | | id | |
| person_id | person Table. | patient | Resource Reference |
| drug_concept_id | concept Table. concept_code (code), concept_name (display), vocabulary_id (vocabulary table – need to convert to system URI) |  medication[x] | Complex Data Type: medicationCodeableConcept |
| drug_exposure_start_date | | whenPrepared | |
| quantity, dose_unit_concept_id | concept table for unit | quantity | |
| days_supply | | daysSupply | |
| | | | |
| ***Table*: drug_exposure where drug_type_concept_id = 38000179 or 43542356 or 43542357 or 43542358 Or "Physician administered drug \*"** | **Note** | ***Resource*: MedicationAdministration** | **Note** |
| drug_exposure_id | | id | |
| person_id | person Table. | patient | Resource Reference |
| drug_concept_id | concept Table. concept_code (code), concept_name (display), vocabulary_id (vocabulary table – need to convert to system URI) | medication[x] | Complex Data Type: medicationCodeableConcept |
| stop_reason and/or drug_exposure_start(end)\_date | Use these fields to guess what to put in the status field in FHIR |status | Should be one of in-progress, on-hold, completed, entered-in-error, stopped. If stop_reason in OMOP is not null, use stopped. Otherwise, look at the date range to decide if this is in-progress (within range) or completed (past) or on-hold (future). (based on current date). |
| effective_drug_dose, dose_unit_concept_id, quantity | Use concept table for unit. if effective_drug_dose is not available, use quantity column for the dosage.quantity.value in FHIR. In this case, we don’ t know the unit. Thus, this will contain only the quantity. | dosage.quantity | SimpleQuantity |
| drug_exposure_start_date, drug_exposure_end_date | effectiveTime[x], [x] =DateTime if end_date = null, [x] = Period otherwise | |
| | | | |
| ***Table*: measurement and observation merged to view** | **Note: We named the view as "f_observation_view"** | ***Resource*: Observation** | **Note** |
| observation_id | We are joining two tables. And, IDs can be same. All IDs from observation table will be negated (‘-‘ prepended) in the view. Original tables do not need any modifications. | id | |
| person_id | person Table. | subject •	Person (REQUIRED in OMOP) | Resource Reference |
| observation_concept_id (measurement table – measurement_concept_id) | concept table | code | Complex Data Type: CodeableConcept.  Code will be overwritten for blood pressure as combined value. |
| value_as_number, value_as_string (only for observation table), value_as_concept_id | valueQuantity, valueString, valueCodeableConcept | This is value[x] |
| range_low, range_hight | | referenceRange.low, referenceRange.high | |
| | | status = FINAL | Status is required field in FHIR. This is hard-coded. OMOP data are final. |
| observation_date & observation_time, measurement_date & measurement_time | | effectiveDateTime | Effective[x] |
| measurement_type_concept_id, observation_type_concept_id | This is required column in OMOP v5 | category | CodeableConcept (https://www.hl7.org/fhir/valueset-observation-category.html). See \*\* for mapping of category to omop v5 type concept ID. |
| visit_occurrence_id | visit_occurrence table | encounter | Resource Reference | |
| | | | |
| ***Table*: person** | **Note** | ***Resource*: Patient** | **Note** |
| person_id | | Id | |
| year_of_birth, month_of_birth, day_of_birth | | birthDate | |
| location_id | location table | address | Complex Data Type: Address
| gender_concept_id | concept table | gender | OMOP gender concept needs to map to AdministrativeGender Enum |
| family_name, given1_name, given2_name, prefix_name, suffix_name, preferred_language, ssn, maritalstatus_concept_id, active | f_person table – This is one of custom tables to provide data elements that are not available in OMOP v5 | family, given (list), maritalStatus, active | |
| | | race_concept_id = Unknown (8552) | FHIR person does not have race data element.|
| | | | |
| ***Table*: procedure_occurrence** | **Note** | ***Resource*: Procedure** | **Note** |
| procedure_occurrence_id | | id | |
| person_id | person Table. | subject | Resource Reference |
| procedure_concept_id | concept table | code | Complex Data Type: CodeableConcept |
| | | status = IN_PROGRESS | Hard-coded |
| procedure_date | | performedDateTime | performed{x} |
| | | | |
| ***Table*: provider** | **Note** | ***Resource*: Practitioner** | **Note** |
| provider_id | | Id | |
| provider_name | | name | OMOP v5 has entire name in one field. There is no rule on format. So, we put entire name to text field. |
| gender_concept_id | | gender | |
| year_of_birth | | birthDate | Only year is available |
| care_site_id | | practitionerRole.managingOrganization | |
| specialty_concept_id | concept table practitionerRole.specialty | CodeableConcept | |
| | | | |
|***Table*: visit_occurrence** | **Note** | ***Resource*: Encounter** | **Note** |
| visit_occurrence_id | | id | |
| persion_id | person table | patient | Resource Reference |
| visit_concept_id | concept table | class | |
| visit_start_date & visit_start_time, visit_end_date & visit_end_time | | period | |
| visit_type_concept_id | 44818518 (Visit derived from EHR) | | |
| care_site_id | | serviceProvider (Organization) | Resource Reference |
| provider_id | | participant.individual | Resource Reference |
| | | | |
| ***Table*: device_exposure** | **Note** | ***Resource*: Device** | **Note** |
| device_exposure_id | | id | |
| person_id | | patient | Resource Reference |
| device_concept_id | | type | CodeableConcept |
| device_exposure_start_date | This is not mappable. For CREATE from FHIR, this can be a problem. | | |
| device_exposure_end_date | | | |
| device_type_concept_id | This is required, but not mapperable. | | |
| unique_device_id | | udi | |
| provider_id | provider.care_site_id | owner (Organization) | |
| quantity | Is it possible to have multiple devices with the same UDI? | | Device Resource does not have quantity information. |
| visit_occurrence_id | visit_occurrence.care_site \_id if provider_id is not available. | owner (Organization) | Resource Reference |

## Mapping Implementation in GT-FHIR v2
While v1 makes a direct mapping as shown on the table above, the v2 will use intermediate (or staging) tables/databases for FHIR to OMOP CDM mappings. This new approach serves two critical operational needs.

 1. Data Validation and Coding Transformations: For more in-depth data validations, the FHIR resources will be intially mapped to the intermediate data schema, which is designed to adapt FHIR and OMOP CDM. When a ETL procedure is executed, the data will be validated and transformed to appropriate concept data in OMOP CDM. This allows the data stored in OMOP CDM to be better ready for such as analytic applications.
 2. Pre-processing Clinical Data: When the OMOP tables are populated from the intermediate table, the other supplmental tables such as *_era tables are also populated.
