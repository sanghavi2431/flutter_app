# Refactoring Project Board Template
## Use this for Jira, GitHub Projects, or Linear

---

## 📋 Board Structure

### Columns:
1. **Backlog** - Planned tasks
2. **To Do** - Ready to start
3. **In Progress** - Currently working
4. **Code Review** - Awaiting review
5. **Testing** - In testing phase
6. **Done** - Completed

---

## 🎯 Phase 1: Foundation & Critical Files (Weeks 1-3)

### Week 1: Setup & Quick Wins

#### Setup Infrastructure
- [ ] **Task:** Create directory structure
  - **Assignee:** TBD
  - **Estimate:** 2 hours
  - **Status:** ⏳ Pending
  - **Dependencies:** None

- [ ] **Task:** Update analysis_options.yaml
  - **Assignee:** TBD
  - **Estimate:** 1 hour
  - **Status:** ⏳ Pending
  - **Dependencies:** None

- [ ] **Task:** Create base classes template
  - **Assignee:** TBD
  - **Estimate:** 2 hours
  - **Status:** ⏳ Pending
  - **Dependencies:** Directory structure

#### Extract Form Validators
- [ ] **Task:** Create form_validators.dart
  - **Assignee:** TBD
  - **Estimate:** 4 hours
  - **Status:** ⏳ Pending
  - **Dependencies:** Directory structure

- [ ] **Task:** Extract validators from home.dart
  - **Assignee:** TBD
  - **Estimate:** 3 hours
  - **Status:** ⏳ Pending
  - **Dependencies:** form_validators.dart created

- [ ] **Task:** Extract validators from assign_tasks_screen.dart
  - **Assignee:** TBD
  - **Estimate:** 2 hours
  - **Status:** ⏳ Pending
  - **Dependencies:** form_validators.dart created

- [ ] **Task:** Update all imports
  - **Assignee:** TBD
  - **Estimate:** 1 hour
  - **Status:** ⏳ Pending
  - **Dependencies:** All validators extracted

---

### Week 2: Extract Bottom Sheets (Part 1)

#### Admin Bottom Sheet
- [ ] **Task:** Create admin_bottom_sheet.dart
  - **Assignee:** Developer 1
  - **Estimate:** 2 hours
  - **Status:** ⏳ Pending
  - **Dependencies:** Week 1 complete

- [ ] **Task:** Extract adminBottomSheet() method
  - **Assignee:** Developer 1
  - **Estimate:** 4 hours
  - **Status:** ⏳ Pending
  - **Dependencies:** File created

- [ ] **Task:** Move related state and controllers
  - **Assignee:** Developer 1
  - **Estimate:** 2 hours
  - **Status:** ⏳ Pending
  - **Dependencies:** Method extracted

- [ ] **Task:** Update home.dart to use extracted widget
  - **Assignee:** Developer 1
  - **Estimate:** 1 hour
  - **Status:** ⏳ Pending
  - **Dependencies:** State moved

- [ ] **Task:** Test admin bottom sheet functionality
  - **Assignee:** Developer 1
  - **Estimate:** 1 hour
  - **Status:** ⏳ Pending
  - **Dependencies:** Integration complete

#### Supervisor Bottom Sheet
- [ ] **Task:** Create supervisor_bottom_sheet.dart
  - **Assignee:** Developer 2
  - **Estimate:** 2 hours
  - **Status:** ⏳ Pending
  - **Dependencies:** Week 1 complete

- [ ] **Task:** Extract superVisorBottomSheet() method
  - **Assignee:** Developer 2
  - **Estimate:** 4 hours
  - **Status:** ⏳ Pending
  - **Dependencies:** File created

- [ ] **Task:** Move related state and controllers
  - **Assignee:** Developer 2
  - **Estimate:** 2 hours
  - **Status:** ⏳ Pending
  - **Dependencies:** Method extracted

- [ ] **Task:** Update home.dart to use extracted widget
  - **Assignee:** Developer 2
  - **Estimate:** 1 hour
  - **Status:** ⏳ Pending
  - **Dependencies:** State moved

- [ ] **Task:** Test supervisor bottom sheet functionality
  - **Assignee:** Developer 2
  - **Estimate:** 1 hour
  - **Status:** ⏳ Pending
  - **Dependencies:** Integration complete

#### Janitor Bottom Sheet
- [ ] **Task:** Create janitor_bottom_sheet.dart
  - **Assignee:** Developer 1
  - **Estimate:** 1 hour
  - **Status:** ⏳ Pending
  - **Dependencies:** Admin bottom sheet complete

- [ ] **Task:** Extract janitorBottomSheet() method
  - **Assignee:** Developer 1
  - **Estimate:** 2 hours
  - **Status:** ⏳ Pending
  - **Dependencies:** File created

- [ ] **Task:** Move related state and controllers
  - **Assignee:** Developer 1
  - **Estimate:** 1 hour
  - **Status:** ⏳ Pending
  - **Dependencies:** Method extracted

- [ ] **Task:** Update home.dart and test
  - **Assignee:** Developer 1
  - **Estimate:** 1 hour
  - **Status:** ⏳ Pending
  - **Dependencies:** State moved

---

### Week 3: Extract Bottom Sheets (Part 2) & Dialogs

#### Facility Bottom Sheet
- [ ] **Task:** Create facility_bottom_sheet.dart
  - **Assignee:** Developer 1
  - **Estimate:** 2 hours
  - **Status:** ⏳ Pending

- [ ] **Task:** Extract facility selection logic
  - **Assignee:** Developer 1
  - **Estimate:** 4 hours
  - **Status:** ⏳ Pending

- [ ] **Task:** Update home.dart and test
  - **Assignee:** Developer 1
  - **Estimate:** 2 hours
  - **Status:** ⏳ Pending

#### Extract Dialogs
- [ ] **Task:** Review existing dialogs
  - **Assignee:** Developer 2
  - **Estimate:** 2 hours
  - **Status:** ⏳ Pending

- [ ] **Task:** Extract remaining inline dialogs
  - **Assignee:** Developer 2
  - **Estimate:** 4 hours
  - **Status:** ⏳ Pending

- [ ] **Task:** Standardize dialog structure
  - **Assignee:** Developer 2
  - **Estimate:** 2 hours
  - **Status:** ⏳ Pending

#### Code Review & Testing
- [ ] **Task:** Full code review
  - **Assignee:** Both
  - **Estimate:** 2 hours
  - **Status:** ⏳ Pending

- [ ] **Task:** Integration testing
  - **Assignee:** Both
  - **Estimate:** 2 hours
  - **Status:** ⏳ Pending

- [ ] **Task:** Update documentation
  - **Assignee:** Developer 1
  - **Estimate:** 1 hour
  - **Status:** ⏳ Pending

---

## 🎯 Phase 2: assign_tasks_screen.dart (Weeks 4-5)

### Week 4: Extract Time & Days Widgets

#### Time Input Widget
- [ ] **Task:** Create task_time_input_widget.dart
  - **Assignee:** Developer 1
  - **Estimate:** 2 hours
  - **Status:** ⏳ Pending

- [ ] **Task:** Extract time input field with AM/PM
  - **Assignee:** Developer 1
  - **Estimate:** 4 hours
  - **Status:** ⏳ Pending

- [ ] **Task:** Move time-related state
  - **Assignee:** Developer 1
  - **Estimate:** 2 hours
  - **Status:** ⏳ Pending

- [ ] **Task:** Extract time formatting logic
  - **Assignee:** Developer 1
  - **Estimate:** 2 hours
  - **Status:** ⏳ Pending

#### Days Selection Widget
- [ ] **Task:** Create days_selection_widget.dart
  - **Assignee:** Developer 2
  - **Estimate:** 2 hours
  - **Status:** ⏳ Pending

- [ ] **Task:** Extract days selection UI
  - **Assignee:** Developer 2
  - **Estimate:** 4 hours
  - **Status:** ⏳ Pending

- [ ] **Task:** Move days-related state
  - **Assignee:** Developer 2
  - **Estimate:** 2 hours
  - **Status:** ⏳ Pending

- [ ] **Task:** Extract days validation
  - **Assignee:** Developer 2
  - **Estimate:** 2 hours
  - **Status:** ⏳ Pending

#### Estimated Time Widget
- [ ] **Task:** Create estimated_time_input_widget.dart
  - **Assignee:** Developer 1
  - **Estimate:** 1 hour
  - **Status:** ⏳ Pending

- [ ] **Task:** Extract estimated time input
  - **Assignee:** Developer 1
  - **Estimate:** 2 hours
  - **Status:** ⏳ Pending

- [ ] **Task:** Move validation logic
  - **Assignee:** Developer 1
  - **Estimate:** 1 hour
  - **Status:** ⏳ Pending

---

### Week 5: Extract Added Tasks & Validation

#### Added Tasks List Widget
- [ ] **Task:** Create added_tasks_list_widget.dart
  - **Assignee:** Developer 1
  - **Estimate:** 2 hours
  - **Status:** ⏳ Pending

- [ ] **Task:** Extract "Added Tasks" section
  - **Assignee:** Developer 1
  - **Estimate:** 4 hours
  - **Status:** ⏳ Pending

- [ ] **Task:** Extract task card widget
  - **Assignee:** Developer 1
  - **Estimate:** 2 hours
  - **Status:** ⏳ Pending

- [ ] **Task:** Move expansion logic
  - **Assignee:** Developer 1
  - **Estimate:** 2 hours
  - **Status:** ⏳ Pending

#### Validation Helpers
- [ ] **Task:** Create task_validation_helper.dart
  - **Assignee:** Developer 2
  - **Estimate:** 1 hour
  - **Status:** ⏳ Pending

- [ ] **Task:** Extract overlap checking logic
  - **Assignee:** Developer 2
  - **Estimate:** 3 hours
  - **Status:** ⏳ Pending

- [ ] **Task:** Extract time validation
  - **Assignee:** Developer 2
  - **Estimate:** 2 hours
  - **Status:** ⏳ Pending

- [ ] **Task:** Create task_time_builder.dart
  - **Assignee:** Developer 2
  - **Estimate:** 1 hour
  - **Status:** ⏳ Pending

- [ ] **Task:** Extract _buildTaskTimesFromModel
  - **Assignee:** Developer 2
  - **Estimate:** 3 hours
  - **Status:** ⏳ Pending

#### Success Dialog
- [ ] **Task:** Create success_dialog.dart
  - **Assignee:** Developer 1
  - **Estimate:** 1 hour
  - **Status:** ⏳ Pending

- [ ] **Task:** Extract _showSuccessDialog
  - **Assignee:** Developer 1
  - **Estimate:** 2 hours
  - **Status:** ⏳ Pending

- [ ] **Task:** Standardize dialog structure
  - **Assignee:** Developer 1
  - **Estimate:** 1 hour
  - **Status:** ⏳ Pending

---

## 🎯 Phase 3: High Priority Files (Weeks 6-7)

### Week 6: product_details.dart

- [ ] **Task:** Extract image gallery widget
  - **Assignee:** TBD
  - **Estimate:** 8 hours
  - **Status:** ⏳ Pending

- [ ] **Task:** Extract reviews section
  - **Assignee:** TBD
  - **Estimate:** 4 hours
  - **Status:** ⏳ Pending

- [ ] **Task:** Extract variants selector
  - **Assignee:** TBD
  - **Estimate:** 4 hours
  - **Status:** ⏳ Pending

- [ ] **Task:** Extract add to cart section
  - **Assignee:** TBD
  - **Estimate:** 4 hours
  - **Status:** ⏳ Pending

- [ ] **Task:** Testing and integration
  - **Assignee:** TBD
  - **Estimate:** 4 hours
  - **Status:** ⏳ Pending

---

### Week 7: Base Classes & Shared Widgets

- [ ] **Task:** Create base_bottom_sheet.dart
  - **Assignee:** TBD
  - **Estimate:** 4 hours
  - **Status:** ⏳ Pending

- [ ] **Task:** Create base_dialog.dart
  - **Assignee:** TBD
  - **Estimate:** 4 hours
  - **Status:** ⏳ Pending

- [ ] **Task:** Create shared loading indicator
  - **Assignee:** TBD
  - **Estimate:** 2 hours
  - **Status:** ⏳ Pending

- [ ] **Task:** Create shared error widget
  - **Assignee:** TBD
  - **Estimate:** 2 hours
  - **Status:** ⏳ Pending

- [ ] **Task:** Create shared empty state widget
  - **Assignee:** TBD
  - **Estimate:** 2 hours
  - **Status:** ⏳ Pending

- [ ] **Task:** Refactor existing components
  - **Assignee:** TBD
  - **Estimate:** 6 hours
  - **Status:** ⏳ Pending

---

## 🎯 Phase 4: Standardization (Week 8)

- [ ] **Task:** Create documentation
  - **Assignee:** TBD
  - **Estimate:** 6 hours
  - **Status:** ⏳ Pending

- [ ] **Task:** Final code review
  - **Assignee:** TBD
  - **Estimate:** 4 hours
  - **Status:** ⏳ Pending

- [ ] **Task:** Remove commented code
  - **Assignee:** TBD
  - **Estimate:** 2 hours
  - **Status:** ⏳ Pending

- [ ] **Task:** Fix linting issues
  - **Assignee:** TBD
  - **Estimate:** 2 hours
  - **Status:** ⏳ Pending

- [ ] **Task:** Full test suite
  - **Assignee:** TBD
  - **Estimate:** 3 hours
  - **Status:** ⏳ Pending

- [ ] **Task:** Performance testing
  - **Assignee:** TBD
  - **Estimate:** 2 hours
  - **Status:** ⏳ Pending

---

## 📊 Progress Tracking

### Weekly Metrics Template:

**Week [X] Summary:**
- **Components Extracted:** X
- **Lines Reduced:** X
- **Files Created:** X
- **Tests Passing:** X/X
- **Time Spent:** X hours
- **Blockers:** X

### Overall Progress:
- **Phase 1:** X% complete
- **Phase 2:** X% complete
- **Phase 3:** X% complete
- **Phase 4:** X% complete
- **Overall:** X% complete

---

## 🏷️ Labels/Tags

Use these labels for filtering:
- `critical` - Must complete
- `high-priority` - Important
- `medium-priority` - Nice to have
- `blocked` - Waiting on something
- `in-review` - Code review pending
- `testing` - In testing phase
- `documentation` - Documentation task

---

## 📝 Notes Section

Use this for:
- Important decisions
- Lessons learned
- Blockers and resolutions
- Team feedback

---

**Last Updated:** 2025-01-27  
**Next Update:** After Week 1 completion

