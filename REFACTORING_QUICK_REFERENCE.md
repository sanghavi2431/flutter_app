# Refactoring Quick Reference Guide
## Quick Start & Daily Operations

---

## 🚀 Quick Start (First Day)

### 1. Setup (2-3 hours)
```bash
# Create directory structure
mkdir -p lib/client_flow/screens/dashbaord/view/home/{widgets,bottomsheets,dialogs,helpers}
mkdir -p lib/shared/{base,widgets}
mkdir -p lib/client_flow/screens/dashbaord/view/assign_task/{widgets,helpers,dialogs}

# Update analysis_options.yaml
# Add linting rules (see REFACTORING_PLAN.md)
```

### 2. First Extraction: Form Validators (4-6 hours)
- Create: `lib/client_flow/screens/dashbaord/view/home/helpers/form_validators.dart`
- Extract all validation functions
- Update imports
- Test

---

## 📋 Daily Workflow

### Morning (30 min)
1. Review assigned tasks
2. Check progress metrics
3. Update status in project board
4. Sync with team

### During Work
1. **Before Extracting:**
   - Read the code section thoroughly
   - Identify dependencies
   - Plan the extraction
   - Create new file structure

2. **While Extracting:**
   - Copy code to new file
   - Fix imports
   - Update state management
   - Add necessary parameters
   - Test incrementally

3. **After Extracting:**
   - Update original file to use new widget
   - Remove old code
   - Run tests
   - Update documentation
   - Commit with clear message

### End of Day (15 min)
1. Update progress metrics
2. Commit changes
3. Update project board
4. Note any blockers

---

## 🎯 Extraction Checklist

For each widget/component extraction:

- [ ] **Planning**
  - [ ] Identify code to extract (mark lines)
  - [ ] List all dependencies (controllers, state, imports)
  - [ ] Plan file structure
  - [ ] Estimate time

- [ ] **Extraction**
  - [ ] Create new file
  - [ ] Copy code
  - [ ] Fix imports
  - [ ] Add required parameters
  - [ ] Handle state properly
  - [ ] Add documentation

- [ ] **Integration**
  - [ ] Update original file
  - [ ] Replace with new widget
  - [ ] Remove old code
  - [ ] Update all imports

- [ ] **Testing**
  - [ ] Manual testing
  - [ ] Run unit tests
  - [ ] Check for linting errors
  - [ ] Verify functionality

- [ ] **Cleanup**
  - [ ] Code review
  - [ ] Update documentation
  - [ ] Commit with clear message
  - [ ] Update metrics

---

## 📐 Extraction Patterns

### Pattern 1: Bottom Sheet Extraction

**Before:**
```dart
// In home.dart
void adminBottomSheet() {
  showModalBottomSheet(
    // ... 200 lines of code
  );
}
```

**After:**
```dart
// In home.dart
void adminBottomSheet() {
  showModalBottomSheet(
    context: context,
    builder: (context) => AdminBottomSheet(
      // Pass required parameters
    ),
  );
}

// In bottomsheets/admin_bottom_sheet.dart
class AdminBottomSheet extends StatelessWidget {
  // Extracted code
}
```

### Pattern 2: Widget Extraction

**Before:**
```dart
// In screen.dart
Widget build(BuildContext context) {
  return Column(
    children: [
      // ... 150 lines of widget code
    ],
  );
}
```

**After:**
```dart
// In screen.dart
Widget build(BuildContext context) {
  return Column(
    children: [
      ExtractedWidget(
        // Pass required data
      ),
    ],
  );
}

// In widgets/extracted_widget.dart
class ExtractedWidget extends StatelessWidget {
  // Extracted code
}
```

### Pattern 3: Helper Function Extraction

**Before:**
```dart
// In screen.dart
String validateEmail(String value) {
  // validation logic
}
```

**After:**
```dart
// In helpers/form_validators.dart
class FormValidators {
  static String? validateEmail(String? value) {
    // validation logic
  }
}

// In screen.dart
import 'helpers/form_validators.dart';
// Use: FormValidators.validateEmail(value)
```

---

## 🔍 Code Review Checklist

### For Extracted Components:
- [ ] File name follows convention
- [ ] Proper imports
- [ ] No unused code
- [ ] Proper documentation
- [ ] State management correct
- [ ] Error handling present
- [ ] No hardcoded values
- [ ] Responsive design maintained

### For Original File:
- [ ] Old code removed
- [ ] Imports updated
- [ ] No broken references
- [ ] Functionality preserved
- [ ] Code reduced significantly

---

## 📊 Progress Tracking

### Daily Metrics to Track:
- Lines of code reduced
- Files created
- Components extracted
- Tests passing
- Time spent

### Weekly Metrics:
- Phase completion %
- Overall progress %
- Blockers resolved
- Code review completion

---

## 🚨 Common Issues & Solutions

### Issue 1: State Not Updating
**Solution:** Ensure state is properly passed as parameters or use proper state management

### Issue 2: Import Errors
**Solution:** Use IDE refactoring tools, check relative vs absolute imports

### Issue 3: Breaking Functionality
**Solution:** Test incrementally, keep original code commented for 1 week

### Issue 4: Circular Dependencies
**Solution:** Review imports, use dependency injection if needed

### Issue 5: Too Many Parameters
**Solution:** Create a model class to group related parameters

---

## 💡 Best Practices

1. **Extract Incrementally**
   - One component at a time
   - Test after each extraction
   - Don't extract multiple things at once

2. **Keep It Simple**
   - Don't over-engineer
   - Start with simple extraction
   - Refine later if needed

3. **Test Thoroughly**
   - Manual testing is crucial
   - Automated tests are bonus
   - Test edge cases

4. **Document Changes**
   - Clear commit messages
   - Update documentation
   - Note breaking changes

5. **Code Review**
   - Get review before merging
   - Address feedback promptly
   - Learn from reviews

---

## 📞 Communication

### When to Ask for Help:
- Unclear requirements
- Complex dependencies
- Breaking changes
- Timeline concerns
- Technical blockers

### Daily Standup Format:
1. What did I extract yesterday?
2. What am I extracting today?
3. Any blockers?

### Weekly Review Format:
1. Progress this week
2. Metrics update
3. Next week plan
4. Risks/concerns

---

## 🎯 Success Indicators

### Good Progress:
- ✅ Extracting 1-2 components per day
- ✅ Reducing 200-400 lines per extraction
- ✅ All tests passing
- ✅ No breaking changes

### Warning Signs:
- ⚠️ Taking > 1 day per extraction
- ⚠️ Tests failing
- ⚠️ Breaking functionality
- ⚠️ Increasing complexity

---

## 📚 Resources

### Documentation:
- `MODULARIZATION_REVIEW.md` - Full analysis
- `REFACTORING_PLAN.md` - Detailed plan
- This file - Quick reference

### Tools:
- IDE refactoring (VS Code/Android Studio)
- Flutter analyzer
- Git for version control
- Project board for tracking

---

**Last Updated:** 2025-01-27  
**For Questions:** Refer to REFACTORING_PLAN.md or team lead

