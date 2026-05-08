# Refactoring Implementation Plan
## Woloo-Janitor-Flutter Modularization

**Created:** 2025-01-27  
**Status:** Planning Phase  
**Estimated Duration:** 6-8 weeks (depending on team size)

---

## 📋 Team Capacity Assumptions

### Scenario 1: Small Team (1-2 Developers)
- **Available Hours:** 20-30 hours/week per developer
- **Focus:** Critical issues only
- **Timeline:** 8-10 weeks

### Scenario 2: Medium Team (2-3 Developers)
- **Available Hours:** 30-40 hours/week per developer
- **Focus:** Critical + High Priority
- **Timeline:** 6-8 weeks

### Scenario 3: Large Team (3+ Developers)
- **Available Hours:** 40+ hours/week per developer
- **Focus:** All priorities
- **Timeline:** 4-6 weeks

**Note:** This plan assumes **Medium Team (2-3 developers)** with 30% of time allocated to refactoring alongside feature development.

---

## 🎯 Refactoring Phases

### **PHASE 1: Foundation & Critical Files** (Weeks 1-3)
**Goal:** Address the most critical issues that impact daily development

#### Week 1: Setup & Quick Wins
**Duration:** 5 days  
**Effort:** 15-20 hours  
**Team:** 1-2 developers

**Tasks:**
1. **Day 1-2: Setup Infrastructure** (4-6 hours)
   - Create base directory structure
   - Set up shared widgets directory
   - Create base classes template
   - Update analysis_options.yaml with linting rules
   - **Deliverable:** Directory structure ready

2. **Day 3-5: Extract Form Validators** (8-10 hours)
   - Create `lib/client_flow/screens/dashbaord/view/home/helpers/form_validators.dart`
   - Extract all validation functions from `home.dart`
   - Extract validation from `assign_tasks_screen.dart`
   - Update imports across codebase
   - **Deliverable:** Centralized validation logic
   - **Risk:** Low
   - **Impact:** High (reduces duplication)

**Success Criteria:**
- ✅ All validation functions in one place
- ✅ No duplicate validation logic
- ✅ All screens using shared validators

---

#### Week 2: Extract Bottom Sheets from home.dart (Part 1)
**Duration:** 5 days  
**Effort:** 20-25 hours  
**Team:** 2 developers

**Tasks:**
1. **Day 1-2: Extract Admin Bottom Sheet** (8-10 hours)
   - Create `lib/client_flow/screens/dashbaord/view/home/bottomsheets/admin_bottom_sheet.dart`
   - Extract `adminBottomSheet()` method (lines ~1718-1848)
   - Move related state and controllers
   - Update `home.dart` to use extracted widget
   - Test functionality
   - **Developer:** Developer 1

2. **Day 3-4: Extract Supervisor Bottom Sheet** (8-10 hours)
   - Create `lib/client_flow/screens/dashbaord/view/home/bottomsheets/supervisor_bottom_sheet.dart`
   - Extract `superVisorBottomSheet()` method (lines ~1851+)
   - Move related state and controllers
   - Update `home.dart` to use extracted widget
   - Test functionality
   - **Developer:** Developer 2

3. **Day 5: Extract Janitor Bottom Sheet** (4-5 hours)
   - Create `lib/client_flow/screens/dashbaord/view/home/bottomsheets/janitor_bottom_sheet.dart`
   - Extract `janitorBottomSheet()` method (lines ~3000+)
   - Move related state and controllers
   - Update `home.dart` to use extracted widget
   - Test functionality
   - **Developer:** Developer 1

**Success Criteria:**
- ✅ 3 bottom sheets extracted to separate files
- ✅ `home.dart` reduced by ~500-800 lines
- ✅ All functionality working as before
- ✅ No breaking changes

**Risk Mitigation:**
- Test each extraction thoroughly before moving to next
- Keep original code commented for rollback if needed
- Code review after each extraction

---

#### Week 3: Extract Bottom Sheets (Part 2) & Dialogs
**Duration:** 5 days  
**Effort:** 20-25 hours  
**Team:** 2 developers

**Tasks:**
1. **Day 1-2: Extract Facility Bottom Sheet** (8-10 hours)
   - Create `lib/client_flow/screens/dashbaord/view/home/bottomsheets/facility_bottom_sheet.dart`
   - Extract facility selection logic
   - Move related state
   - Update `home.dart`
   - **Developer:** Developer 1

2. **Day 3-4: Extract Remaining Dialogs** (8-10 hours)
   - Review existing dialogs (buddy_list_dialog, select_buddy_dialog)
   - Extract any remaining inline dialogs
   - Create `lib/client_flow/screens/dashbaord/view/home/dialogs/` directory
   - Standardize dialog structure
   - **Developer:** Developer 2

3. **Day 5: Code Review & Testing** (4-5 hours)
   - Full code review of extracted components
   - Integration testing
   - Update documentation
   - **Both Developers**

**Success Criteria:**
- ✅ All bottom sheets extracted
- ✅ All dialogs extracted
- ✅ `home.dart` reduced to < 3000 lines
- ✅ All tests passing

---

### **PHASE 2: assign_tasks_screen.dart Refactoring** (Weeks 4-5)
**Goal:** Continue widget extraction from assign_tasks_screen.dart

#### Week 4: Extract Time & Days Widgets
**Duration:** 5 days  
**Effort:** 20-25 hours  
**Team:** 2 developers

**Tasks:**
1. **Day 1-2: Extract Time Input Widget** (8-10 hours)
   - Create `lib/client_flow/screens/dashbaord/view/assign_task/widgets/task_time_input_widget.dart`
   - Extract time input field with AM/PM toggle
   - Move `shiftTimeController`, `shiftTimeFocusNode`, `isAM` state
   - Extract time formatting logic
   - Update `assign_tasks_screen.dart`
   - **Developer:** Developer 1

2. **Day 3-4: Extract Days Selection Widget** (8-10 hours)
   - Create `lib/client_flow/screens/dashbaord/view/assign_task/widgets/days_selection_widget.dart`
   - Extract days selection UI (checkboxes, "All Days" functionality)
   - Move days-related state
   - Extract days validation logic
   - Update `assign_tasks_screen.dart`
   - **Developer:** Developer 2

3. **Day 5: Extract Estimated Time Widget** (4-5 hours)
   - Create `lib/client_flow/screens/dashbaord/view/assign_task/widgets/estimated_time_input_widget.dart`
   - Extract estimated time input with validation
   - Move `estimatedTimeController`, validation logic
   - Update `assign_tasks_screen.dart`
   - **Developer:** Developer 1

**Success Criteria:**
- ✅ Time input widget extracted
- ✅ Days selection widget extracted
- ✅ Estimated time widget extracted
- ✅ `assign_tasks_screen.dart` reduced by ~400-600 lines

---

#### Week 5: Extract Added Tasks & Validation Helpers
**Duration:** 5 days  
**Effort:** 20-25 hours  
**Team:** 2 developers

**Tasks:**
1. **Day 1-2: Extract Added Tasks List Widget** (8-10 hours)
   - Create `lib/client_flow/screens/dashbaord/view/assign_task/widgets/added_tasks_list_widget.dart`
   - Extract "Added Tasks" section UI
   - Extract task card widget
   - Move expansion/collapse logic
   - Update `assign_tasks_screen.dart`
   - **Developer:** Developer 1

2. **Day 3-4: Extract Validation Helpers** (8-10 hours)
   - Create `lib/client_flow/screens/dashbaord/view/assign_task/helpers/task_validation_helper.dart`
   - Extract overlap checking logic (`isOverlap` function)
   - Extract time validation
   - Extract days validation
   - Create `lib/client_flow/screens/dashbaord/view/assign_task/helpers/task_time_builder.dart`
   - Extract `_buildTaskTimesFromModel` logic
   - Update `assign_tasks_screen.dart`
   - **Developer:** Developer 2

3. **Day 5: Extract Success Dialog** (4-5 hours)
   - Create `lib/client_flow/screens/dashbaord/view/assign_task/dialogs/success_dialog.dart`
   - Extract `_showSuccessDialog` method
   - Standardize dialog structure
   - Update `assign_tasks_screen.dart`
   - **Developer:** Developer 1

**Success Criteria:**
- ✅ Added tasks list widget extracted
- ✅ Validation helpers extracted
- ✅ Success dialog extracted
- ✅ `assign_tasks_screen.dart` reduced to < 1500 lines

---

### **PHASE 3: High Priority Files** (Weeks 6-7)
**Goal:** Refactor other large files

#### Week 6: product_details.dart Refactoring
**Duration:** 5 days  
**Effort:** 20-25 hours  
**Team:** 2 developers

**Tasks:**
1. **Day 1-2: Extract Image Gallery** (8-10 hours)
   - Create `lib/b2b_store/widgets/product_image_gallery.dart`
   - Extract image carousel/gallery logic
   - Move image-related state
   - **Developer:** Developer 1

2. **Day 3-4: Extract Reviews & Variants** (8-10 hours)
   - Create `lib/b2b_store/widgets/product_reviews_section.dart`
   - Create `lib/b2b_store/widgets/product_variants_selector.dart`
   - Extract related logic
   - **Developer:** Developer 2

3. **Day 5: Extract Add to Cart Section** (4-5 hours)
   - Create `lib/b2b_store/widgets/add_to_cart_section.dart`
   - Extract cart logic
   - **Developer:** Developer 1

**Success Criteria:**
- ✅ `product_details.dart` reduced to < 1500 lines
- ✅ All widgets extracted and tested

---

#### Week 7: Create Base Classes & Shared Widgets
**Duration:** 5 days  
**Effort:** 20-25 hours  
**Team:** 2 developers

**Tasks:**
1. **Day 1-2: Create Base Bottom Sheet** (8-10 hours)
   - Create `lib/shared/base/base_bottom_sheet.dart`
   - Standardize bottom sheet structure
   - Create common styling
   - Update existing bottom sheets to extend base
   - **Developer:** Developer 1

2. **Day 3-4: Create Base Dialog & Shared Widgets** (8-10 hours)
   - Create `lib/shared/base/base_dialog.dart`
   - Create `lib/shared/widgets/loading_indicator.dart`
   - Create `lib/shared/widgets/error_widget.dart`
   - Create `lib/shared/widgets/empty_state_widget.dart`
   - **Developer:** Developer 2

3. **Day 5: Refactor Existing Components** (4-5 hours)
   - Update existing dialogs to use base classes
   - Replace inline loading/error widgets with shared ones
   - **Both Developers**

**Success Criteria:**
- ✅ Base classes created and documented
- ✅ Shared widgets available for use
- ✅ At least 3 existing components refactored to use base classes

---

### **PHASE 4: Standardization & Cleanup** (Week 8)
**Goal:** Finalize patterns and documentation

#### Week 8: Documentation & Final Cleanup
**Duration:** 5 days  
**Effort:** 15-20 hours  
**Team:** 1-2 developers

**Tasks:**
1. **Day 1-2: Create Documentation** (6-8 hours)
   - Document widget extraction patterns
   - Create component library documentation
   - Update README with new structure
   - Create architecture decision records (ADRs)
   - **Developer:** Developer 1

2. **Day 3-4: Code Review & Cleanup** (6-8 hours)
   - Final code review of all refactored files
   - Remove commented code
   - Fix any linting issues
   - Update imports
   - **Both Developers**

3. **Day 5: Testing & Validation** (3-4 hours)
   - Run full test suite
   - Manual testing of refactored features
   - Performance testing
   - **Both Developers**

**Success Criteria:**
- ✅ Documentation complete
- ✅ All tests passing
- ✅ No linting errors
- ✅ Code review completed
- ✅ Performance maintained or improved

---

## 📊 Progress Tracking

### Metrics Dashboard

| Phase | Week | Task | Status | Lines Reduced | Files Created |
|-------|------|------|--------|---------------|--------------|
| Phase 1 | 1 | Form Validators | ⏳ Pending | ~200 | 1 |
| Phase 1 | 2 | Admin Bottom Sheet | ⏳ Pending | ~300 | 1 |
| Phase 1 | 2 | Supervisor Bottom Sheet | ⏳ Pending | ~400 | 1 |
| Phase 1 | 2 | Janitor Bottom Sheet | ⏳ Pending | ~500 | 1 |
| Phase 1 | 3 | Facility Bottom Sheet | ⏳ Pending | ~400 | 1 |
| Phase 1 | 3 | Dialogs | ⏳ Pending | ~200 | 2-3 |
| Phase 2 | 4 | Time Input Widget | ⏳ Pending | ~200 | 1 |
| Phase 2 | 4 | Days Selection Widget | ⏳ Pending | ~200 | 1 |
| Phase 2 | 4 | Estimated Time Widget | ⏳ Pending | ~150 | 1 |
| Phase 2 | 5 | Added Tasks List | ⏳ Pending | ~400 | 1 |
| Phase 2 | 5 | Validation Helpers | ⏳ Pending | ~300 | 2 |
| Phase 2 | 5 | Success Dialog | ⏳ Pending | ~100 | 1 |
| Phase 3 | 6 | Product Details Widgets | ⏳ Pending | ~800 | 3 |
| Phase 3 | 7 | Base Classes | ⏳ Pending | N/A | 4-5 |
| Phase 4 | 8 | Documentation | ⏳ Pending | N/A | 3-4 |

**Total Estimated Reduction:** ~4,000-5,000 lines from main files  
**Total Files Created:** ~25-30 new widget/helper files

---

## 🚦 Risk Management

### High Risk Items:
1. **Breaking Changes in home.dart**
   - **Mitigation:** Extract one bottom sheet at a time, test thoroughly
   - **Rollback Plan:** Keep original code commented for 1 week

2. **State Management Issues**
   - **Mitigation:** Carefully track state dependencies
   - **Testing:** Unit tests for extracted widgets

3. **Timeline Overruns**
   - **Mitigation:** Buffer time built into each phase
   - **Contingency:** Can skip Phase 3 if needed

### Medium Risk Items:
1. **Import Conflicts**
   - **Mitigation:** Use IDE refactoring tools
   - **Testing:** Run full build after each extraction

2. **Performance Regression**
   - **Mitigation:** Performance testing after each phase
   - **Monitoring:** Track app startup time, memory usage

---

## 📅 Timeline Summary

### Quick Reference Timeline:

```
Week 1:  Setup & Form Validators
Week 2:  Extract Bottom Sheets (Part 1)
Week 3:  Extract Bottom Sheets (Part 2) & Dialogs
Week 4:  Extract Time & Days Widgets
Week 5:  Extract Added Tasks & Validation
Week 6:  Product Details Refactoring
Week 7:  Base Classes & Shared Widgets
Week 8:  Documentation & Cleanup
```

### Milestones:
- **Week 3 End:** `home.dart` < 3000 lines ✅
- **Week 5 End:** `assign_tasks_screen.dart` < 1500 lines ✅
- **Week 6 End:** `product_details.dart` < 1500 lines ✅
- **Week 8 End:** All documentation complete ✅

---

## 👥 Resource Allocation

### Recommended Team Structure:

**Option A: Dedicated Refactoring Team (2 developers)**
- 100% time on refactoring
- Faster completion (4-5 weeks)
- Less feature development during refactoring

**Option B: Part-Time Refactoring (2-3 developers)**
- 30% time on refactoring, 70% on features
- Slower completion (6-8 weeks)
- Continuous feature development

**Option C: Sprint-Based (2-3 developers)**
- 1 sprint (2 weeks) dedicated to refactoring
- Then 1-2 sprints of features
- Repeat cycle
- Completion: 8-10 weeks

**Recommended:** **Option B** - Balanced approach

---

## ✅ Definition of Done

Each task is considered complete when:
1. ✅ Code extracted to separate file
2. ✅ All imports updated
3. ✅ Functionality tested (manual + automated)
4. ✅ Code reviewed by at least one other developer
5. ✅ No linting errors
6. ✅ Documentation updated
7. ✅ Original code removed (after 1 week verification)

---

## 📝 Weekly Checklist Template

### Week [X] Checklist:
- [ ] Tasks assigned to developers
- [ ] Branch created for phase
- [ ] Daily standup scheduled
- [ ] Code review scheduled
- [ ] Testing plan created
- [ ] Documentation updated
- [ ] Progress metrics updated
- [ ] Risks identified and mitigated

---

## 🎯 Success Metrics

### Code Quality:
- ✅ No file > 1000 lines (except generated)
- ✅ Average file size < 300 lines
- ✅ Code duplication < 5%
- ✅ Test coverage maintained or improved

### Developer Experience:
- ✅ Faster onboarding (new developers)
- ✅ Easier to find code
- ✅ Reduced merge conflicts
- ✅ Improved code review speed

### Maintainability:
- ✅ Easier to add new features
- ✅ Easier to fix bugs
- ✅ Better code organization
- ✅ Clearer architecture

---

## 📞 Communication Plan

### Daily:
- Standup (15 min) - Progress update
- Slack channel for questions

### Weekly:
- Progress review meeting (30 min)
- Metrics dashboard update
- Risk assessment

### Bi-weekly:
- Stakeholder update
- Timeline review
- Adjustments if needed

---

## 🔄 Continuous Improvement

After Phase 4 completion:
1. **Retrospective Meeting**
   - What went well?
   - What could be improved?
   - Lessons learned

2. **Update Guidelines**
   - Refine extraction patterns
   - Update documentation
   - Create templates

3. **Monitor & Maintain**
   - Prevent new large files
   - Code review enforcement
   - Regular refactoring sprints

---

## 📋 Next Steps

1. **Review this plan** with team
2. **Assign developers** to phases
3. **Create project board** (Jira/GitHub Projects)
4. **Set up tracking** (metrics dashboard)
5. **Schedule kickoff meeting**
6. **Begin Week 1 tasks**

---

**Plan Status:** ✅ Ready for Execution  
**Last Updated:** 2025-01-27  
**Next Review:** After Week 1 completion

