import android.view.View
import androidx.test.espresso.Espresso.onView
import androidx.test.espresso.action.ViewActions.*
import androidx.test.espresso.assertion.ViewAssertions.*
import androidx.test.espresso.matcher.ViewMatchers.*
import androidx.test.ext.junit.rules.ActivityScenarioRule
import androidx.test.ext.junit.runners.AndroidJUnit4
import androidx.test.filters.LargeTest
import androidx.test.rule.GrantPermissionRule
import io.flutter.embedding.android.FlutterActivity
import org.hamcrest.Matchers.allOf
import org.hamcrest.core.IsInstanceOf
import org.junit.Rule
import org.junit.Test
import org.junit.runner.RunWith

@LargeTest
@RunWith(AndroidJUnit4::class)
class MainActivityTest {

    @Rule
    @JvmField
    var mActivityScenarioRule = ActivityScenarioRule(FlutterActivity::class.java)

    @Rule
    @JvmField
    var mGrantPermissionRule =
        GrantPermissionRule.grant(
            "android.permission.READ_EXTERNAL_STORAGE",
            "android.permission.POST_NOTIFICATIONS"
        )

    @Test
    fun mainActivityTest() {
        val view = onView(
            allOf(
                withParent(withParent(withId(android.R.id.content))),
                isDisplayed()
            )
        )
        view.check(matches(isDisplayed()))

        val editText = onView(
            allOf(
                withParent(withParent(IsInstanceOf.instanceOf(android.view.View::class.java))),
                isDisplayed()
            )
        )
        editText.check(matches(withText("")))

        val editText2 = onView(
            allOf(
                withParent(withParent(IsInstanceOf.instanceOf(android.view.View::class.java))),
                isDisplayed()
            )
        )
        editText2.check(matches(withText("")))
    }
}
