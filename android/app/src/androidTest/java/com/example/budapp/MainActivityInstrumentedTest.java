package com.example.budapp;

import android.content.Context;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import androidx.test.core.app.ActivityScenario;
import androidx.test.ext.junit.runners.AndroidJUnit4;
import androidx.test.platform.app.InstrumentationRegistry;
import com.example.budapp.utils.ConstructionCalculator;
import org.junit.Test;
import org.junit.runner.RunWith;
import static org.junit.Assert.*;

/**
 * Testy instrumentalne dla aplikacji BudApp
 * Uruchamiane na emulatorze lub fizycznym urządzeniu Android
 * 
 * Aby uruchomić testy:
 * ./gradlew connectedAndroidTest
 * 
 * lub w Android Studio:
 * Kliknij prawym przyciskiem na klasę -> Run 'MainActivityInstrumentedTest'
 */
@RunWith(AndroidJUnit4.class)
public class MainActivityInstrumentedTest {

    // ==================== TESTY KONTEKSTU APLIKACJI ====================
    
    @Test
    public void useAppContext() {
        // Given: Context aplikacji
        Context appContext = InstrumentationRegistry.getInstrumentation().getTargetContext();
        
        // Then: powinien mieć prawidłowy package name
        assertEquals("com.example.budapp", appContext.getPackageName());
    }
    
    @Test
    public void appContext_IsNotNull() {
        // Given: Context aplikacji
        Context appContext = InstrumentationRegistry.getInstrumentation().getTargetContext();
        
        // Then: nie powinien być null
        assertNotNull(appContext);
    }
    
    @Test
    public void appContext_HasValidApplicationInfo() {
        // Given: Context aplikacji
        Context appContext = InstrumentationRegistry.getInstrumentation().getTargetContext();
        
        // Then: powinien mieć prawidłowe informacje o aplikacji
        assertNotNull(appContext.getApplicationInfo());
        assertNotNull(appContext.getApplicationContext());
    }

    // ==================== TESTY PACKAGE MANAGER ====================
    
    @Test
    public void packageManager_CanGetPackageInfo() throws Exception {
        // Given: Context i PackageManager
        Context appContext = InstrumentationRegistry.getInstrumentation().getTargetContext();
        PackageManager pm = appContext.getPackageManager();
        
        // When: pobieramy informacje o pakiecie
        PackageInfo packageInfo = pm.getPackageInfo(appContext.getPackageName(), 0);
        
        // Then: powinny być dostępne
        assertNotNull(packageInfo);
        assertEquals("com.example.budapp", packageInfo.packageName);
    }
    
    @Test
    public void packageManager_AppHasVersionInfo() throws Exception {
        // Given: Context i PackageManager
        Context appContext = InstrumentationRegistry.getInstrumentation().getTargetContext();
        PackageManager pm = appContext.getPackageManager();
        PackageInfo packageInfo = pm.getPackageInfo(appContext.getPackageName(), 0);
        
        // Then: powinien mieć informacje o wersji
        assertNotNull(packageInfo.versionName);
        assertTrue(packageInfo.versionCode > 0 || packageInfo.getLongVersionCode() > 0);
    }

    // ==================== TESTY ACTIVITY ====================
    
    @Test
    public void mainActivity_CanBeLaunched() {
        // Given/When: uruchamiamy MainActivity
        try (ActivityScenario<MainActivity> scenario = ActivityScenario.launch(MainActivity.class)) {
            // Then: activity powinna być w stanie RESUMED
            scenario.onActivity(activity -> {
                assertNotNull(activity);
                assertFalse(activity.isFinishing());
                assertFalse(activity.isDestroyed());
            });
        }
    }
    
    @Test
    public void mainActivity_HasValidContext() {
        // Given/When: uruchamiamy MainActivity
        try (ActivityScenario<MainActivity> scenario = ActivityScenario.launch(MainActivity.class)) {
            // Then: activity powinna mieć prawidłowy context
            scenario.onActivity(activity -> {
                assertNotNull(activity.getApplicationContext());
                assertNotNull(activity.getBaseContext());
                assertNotNull(activity.getResources());
            });
        }
    }

    // ==================== TESTY INTEGRACYJNE KALKULATORA ====================
    
    @Test
    public void constructionCalculator_WorksInAndroidEnvironment() {
        // Given: kalkulator budowlany
        // When: wykonujemy obliczenia
        double area = ConstructionCalculator.calculateArea(5.0, 4.0);
        double cost = ConstructionCalculator.calculateWorkCost(area, 50.0);
        
        // Then: wyniki powinny być prawidłowe
        assertEquals(20.0, area, 0.001);
        assertEquals(1000.0, cost, 0.001);
    }
    
    @Test
    public void constructionCalculator_EmailValidation_WorksOnDevice() {
        // Given: różne formaty emaili
        String validEmail = "test@example.com";
        String invalidEmail = "invalid-email";
        
        // When: sprawdzamy poprawność
        boolean isValid = ConstructionCalculator.isValidEmail(validEmail);
        boolean isInvalid = ConstructionCalculator.isValidEmail(invalidEmail);
        
        // Then: walidacja powinna działać
        assertTrue(isValid);
        assertFalse(isInvalid);
    }
    
    @Test
    public void constructionCalculator_PasswordValidation_WorksOnDevice() {
        // Given: różne hasła
        String validPassword = "password123";
        String invalidPassword = "pass";
        
        // When: sprawdzamy poprawność
        boolean isValid = ConstructionCalculator.isValidPassword(validPassword);
        boolean isInvalid = ConstructionCalculator.isValidPassword(invalidPassword);
        
        // Then: walidacja powinna działać
        assertTrue(isValid);
        assertFalse(isInvalid);
    }
    
    @Test
    public void constructionCalculator_VATCalculation_WorksOnDevice() {
        // Given: kwota netto i stawka VAT
        double netAmount = 1000.0;
        double vatRate = 23.0;
        
        // When: obliczamy VAT i brutto
        double vat = ConstructionCalculator.calculateVAT(netAmount, vatRate);
        double gross = ConstructionCalculator.calculateGrossAmount(netAmount, vatRate);
        
        // Then: obliczenia powinny być prawidłowe
        assertEquals(230.0, vat, 0.001);
        assertEquals(1230.0, gross, 0.001);
    }
    
    @Test
    public void constructionCalculator_VolumeCalculation_WorksOnDevice() {
        // Given: wymiary pomieszczenia
        double length = 5.0;
        double width = 4.0;
        double height = 3.0;
        
        // When: obliczamy objętość
        double volume = ConstructionCalculator.calculateVolume(length, width, height);
        
        // Then: wynik powinien być prawidłowy
        assertEquals(60.0, volume, 0.001);
    }
    
    @Test
    public void constructionCalculator_MaterialQuantity_WorksOnDevice() {
        // Given: powierzchnia, zużycie i zapas
        double area = 20.0;
        double usagePerSqm = 2.5;
        double wastePercent = 10.0;
        
        // When: obliczamy ilość materiału
        double quantity = ConstructionCalculator.calculateMaterialQuantity(area, usagePerSqm, wastePercent);
        
        // Then: wynik powinien uwzględniać zapas
        assertEquals(55.0, quantity, 0.001); // 20 * 2.5 = 50, + 10% = 55
    }
    
    @Test
    public void constructionCalculator_CurrencyFormatting_WorksOnDevice() {
        // Given: różne kwoty
        double amount1 = 1000.0;
        double amount2 = 1234.56;
        
        // When: formatujemy kwoty
        String formatted1 = ConstructionCalculator.formatCurrency(amount1);
        String formatted2 = ConstructionCalculator.formatCurrency(amount2);
        
        // Then: wyniki powinny zawierać "PLN"
        assertTrue(formatted1.contains("PLN"));
        assertTrue(formatted2.contains("PLN"));
        assertNotNull(formatted1);
        assertNotNull(formatted2);
    }

    // ==================== TESTY OBSŁUGI BŁĘDÓW ====================
    
    @Test(expected = IllegalArgumentException.class)
    public void constructionCalculator_NegativeArea_ThrowsException() {
        // Given/When: ujemna powierzchnia
        // Then: powinien rzucić wyjątek
        ConstructionCalculator.calculateArea(-5.0, 4.0);
    }
    
    @Test(expected = IllegalArgumentException.class)
    public void constructionCalculator_InvalidVATRate_ThrowsException() {
        // Given/When: nieprawidłowa stawka VAT
        // Then: powinien rzucić wyjątek
        ConstructionCalculator.calculateVAT(1000.0, 150.0);
    }
    
    @Test(expected = IllegalArgumentException.class)
    public void constructionCalculator_InvalidWastePercentage_ThrowsException() {
        // Given/When: nieprawidłowy procent zapasu
        // Then: powinien rzucić wyjątek
        ConstructionCalculator.calculateMaterialQuantity(20.0, 2.5, 150.0);
    }

    // ==================== TESTY RESOURCES ====================
    
    @Test
    public void resources_AreAccessible() {
        // Given: Context aplikacji
        Context appContext = InstrumentationRegistry.getInstrumentation().getTargetContext();
        
        // Then: zasoby powinny być dostępne
        assertNotNull(appContext.getResources());
        assertNotNull(appContext.getResources().getDisplayMetrics());
    }
    
    @Test
    public void resources_HasValidConfiguration() {
        // Given: Context aplikacji
        Context appContext = InstrumentationRegistry.getInstrumentation().getTargetContext();
        
        // Then: konfiguracja powinna być prawidłowa
        assertNotNull(appContext.getResources().getConfiguration());
        assertTrue(appContext.getResources().getConfiguration().screenWidthDp > 0);
        assertTrue(appContext.getResources().getConfiguration().screenHeightDp > 0);
    }
}









