# Scout Daily Job Briefing — {{run_date}}

## Run Summary

- **Run ID:** {{run_id}}
- **Run started:** {{run_started}}
- **Run completed:** {{run_completed}}
- **Duration:** {{run_duration}}
- **Configured company entries:** {{configured_company_entries}}
- **Unique target companies:** {{unique_target_companies}}
- **Batch size:** {{batch_size}}
- **Worker batches created:** {{worker_batches_created}}
- **Workers launched:** {{workers_launched}}
- **Worker batches completed:** {{worker_batches_completed}}
- **Worker batches retried:** {{worker_batches_retried}}
- **Worker batches failed:** {{worker_batches_failed}}
- **Worker batches timed out:** {{worker_batches_timed_out}}
- **Companies assigned:** {{companies_assigned}}
- **Companies completed:** {{companies_completed}}
- **Companies blocked:** {{companies_blocked}}
- **Companies failed:** {{companies_failed}}
- **Companies timed out:** {{companies_timed_out}}
- **Verified jobs discovered:** {{verified_jobs_discovered}}
- **Eligible jobs:** {{eligible_jobs}}
- **Possibly eligible jobs:** {{possibly_eligible_jobs}}
- **Ineligible jobs excluded:** {{ineligible_jobs_excluded}}
- **Duplicates removed:** {{duplicates_removed}}
- **Previously reported jobs recognized:** {{previously_reported_recognized}}
- **New verified matches:** {{new_verified_count}}
- **Changed opportunities:** {{changed_count}}
- **Previously reported jobs omitted:** {{previously_reported_omitted}}
- **Unverified leads:** {{unverified_count}}
- **Complete coverage achieved:** {{complete_coverage}}

## New Verified Matches

{{#each verified_matches}}

### {{rank}}. [{{job_title}} — {{company}}]({{official_job_url}})

- **Location:** {{location}}
- **Work arrangement:** {{work_arrangement}}
- **Opportunity type:** {{opportunity_type}}
- **Employment type:** {{employment_type}}
- **Internship duration:** {{internship_duration}}
- **Compensation:** {{compensation_status}}
- **Start date:** {{start_date}}
- **Posting date:** {{posting_date}}
- **Application deadline:** {{application_deadline}}
- **Official job ID:** {{official_job_id}}
- **Source type:** {{source_type}}
- **Date discovered:** {{date_discovered}}
- **Experience requirement:** {{experience_requirement}}
- **Degree requirement:** {{degree_requirement}}
- **Work-authorization requirement:** {{work_authorization_requirement}}
- **Candidate-fit score:** {{candidate_fit_score}}/100 — {{score_label}}
- **Score breakdown:** {{score_breakdown}}
- **Company priority:** {{company_priority}}
- **Verification confidence:** {{verification_confidence}}
- **Strongest CV evidence:** {{strongest_cv_evidence}}
- **Transferable experience used:** {{transferable_experience_used}}
- **Why it matches:** {{match_reasons}}
- **Important gaps:** {{important_gaps}}
- **Eligibility flags:** {{eligibility_flags}}
- **Uncertainties:** {{uncertainties}}
- **Apply:** [Open the official job posting]({{official_job_url}})

{{/each}}

## Materially Changed Opportunities

{{#each changed_opportunities}}

### [{{job_title}} — {{company}}]({{official_job_url}})

- **Change detected:** {{change_summary}}
- **Current status:** {{current_status}}
- **Candidate-fit score:** {{candidate_fit_score}}/100
- **Verification confidence:** {{verification_confidence}}
- **Apply:** [Open the official job posting]({{official_job_url}})

{{/each}}

## Unverified Leads

{{#each unverified_leads}}

### {{job_title}} — {{company}}

- **Reason it may be relevant:** {{relevance_reason}}
- **Verification problem:** {{verification_problem}}
- **Best available source:** [Open source]({{source_url}})

{{/each}}

## Blocked or Failed Sources

{{#each blocked_sources}}

- **{{company}}:** {{blocker}}
- **Status:** {{status}}

{{/each}}

## Search Coverage

- **Companies completed with matches:** {{companies_completed_with_matches}}
- **Companies completed without matches:** {{companies_completed_without_matches}}
- **Non-target companies discovered:** {{non_target_companies_discovered}}
- **Blocked companies:** {{blocked_company_details}}
- **Failed companies:** {{failed_company_details}}
- **Timed-out companies:** {{timed_out_company_details}}
- **Excluded jobs by reason:** {{excluded_jobs_by_reason}}
- **Search limitations:** {{search_limitations}}

{{#if no_new_verified_matches}}

> No new verified matches were found today.

{{/if}}
