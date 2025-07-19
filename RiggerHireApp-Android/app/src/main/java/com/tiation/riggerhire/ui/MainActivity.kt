package com.tiation.riggerhire.ui

import android.content.Intent
import android.os.Bundle
import android.util.Log
import androidx.appcompat.app.AppCompatActivity
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.platform.ComposeView
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.tiation.riggerhire.R

/**
 * MainActivity for RiggerHire Android App
 * Features dark neon theme with enterprise-grade UI
 */
class MainActivity : AppCompatActivity() {
    
    companion object {
        const val TAG = "MainActivity"
    }
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        
        Log.d(TAG, "🏗️ RiggerHire MainActivity launched")
        
        setContentView(ComposeView(this).apply {
            setContent {
                RiggerHireTheme {
                    MainScreen()
                }
            }
        })
    }
    
    @Composable
    fun MainScreen() {
        Surface(
            modifier = Modifier.fillMaxSize(),
            color = Color(0xFF0D0D0D) // dark_background
        ) {
            LazyColumn(
                modifier = Modifier
                    .fillMaxSize()
                    .padding(16.dp),
                verticalArrangement = Arrangement.spacedBy(24.dp)
            ) {
                item {
                    HeaderSection()
                }
                
                item {
                    WelcomeCard()
                }
                
                item {
                    ActionButtonsSection()
                }
                
                items(getFeaturesList()) { feature ->
                    FeatureCard(feature = feature)
                }
                
                item {
                    StatsSection()
                }
                
                item {
                    FooterSection()
                }
            }
        }
    }
    
    @Composable
    fun HeaderSection() {
        Column(
            modifier = Modifier.fillMaxWidth(),
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            Text(
                text = "🏗️ RiggerHire",
                fontSize = 32.sp,
                fontWeight = FontWeight.Bold,
                color = Color(0x00FFFF), // neon_cyan
                modifier = Modifier.padding(bottom = 8.dp)
            )
            
            Text(
                text = getString(R.string.app_description),
                fontSize = 18.sp,
                color = Color(0xFF00FFFF), // neon_cyan
                textAlign = TextAlign.Center,
                modifier = Modifier.padding(bottom = 4.dp)
            )
            
            Text(
                text = getString(R.string.app_tagline),
                fontSize = 14.sp,
                color = Color(0xFFB3B3B3), // text_secondary
                textAlign = TextAlign.Center,
                lineHeight = 20.sp
            )
        }
    }
    
    @Composable
    fun WelcomeCard() {
        Card(
            modifier = Modifier.fillMaxWidth(),
            shape = RoundedCornerShape(16.dp),
            colors = CardDefaults.cardColors(containerColor = Color(0xFF1A1A1A)), // dark_surface
            elevation = CardDefaults.cardElevation(defaultElevation = 8.dp)
        ) {
            Box(
                modifier = Modifier
                    .fillMaxWidth()
                    .background(
                        Brush.horizontalGradient(
                            colors = listOf(
                                Color(0xFF00FFFF).copy(alpha = 0.1f), // neon_cyan with transparency
                                Color(0xFFFF00FF).copy(alpha = 0.1f)  // neon_magenta with transparency
                            )
                        )
                    )
                    .padding(24.dp)
            ) {
                Column {
                    Text(
                        text = "🎯 Ready to Find Your Next Job?",
                        fontSize = 20.sp,
                        fontWeight = FontWeight.Bold,
                        color = Color(0xFFFFFFFF) // text_primary
                    )
                    
                    Spacer(modifier = Modifier.height(12.dp))
                    
                    Text(
                        text = "Connect with top mining and construction companies across Western Australia. Start your career in the Pilbara region today!",
                        fontSize = 16.sp,
                        color = Color(0xFFB3B3B3), // text_secondary
                        lineHeight = 22.sp
                    )
                }
            }
        }
    }
    
    @Composable
    fun ActionButtonsSection() {
        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.spacedBy(12.dp)
        ) {
            Button(
                onClick = { /* Navigate to Jobs */ },
                modifier = Modifier.weight(1f),
                colors = ButtonDefaults.buttonColors(
                    containerColor = Color(0xFF00FFFF) // neon_cyan
                ),
                shape = RoundedCornerShape(12.dp)
            ) {
                Icon(
                    imageVector = Icons.Default.Work,
                    contentDescription = null,
                    tint = Color(0xFF0D0D0D) // text_on_neon
                )
                Spacer(modifier = Modifier.width(8.dp))
                Text(
                    text = "Browse Jobs",
                    color = Color(0xFF0D0D0D), // text_on_neon
                    fontWeight = FontWeight.Bold
                )
            }
            
            OutlinedButton(
                onClick = { /* Navigate to Profile */ },
                modifier = Modifier.weight(1f),
                colors = ButtonDefaults.outlinedButtonColors(
                    contentColor = Color(0xFF00FFFF) // neon_cyan
                ),
                border = androidx.compose.foundation.BorderStroke(
                    2.dp, 
                    Color(0xFF00FFFF) // neon_cyan
                ),
                shape = RoundedCornerShape(12.dp)
            ) {
                Icon(
                    imageVector = Icons.Default.Person,
                    contentDescription = null,
                    tint = Color(0xFF00FFFF) // neon_cyan
                )
                Spacer(modifier = Modifier.width(8.dp))
                Text(
                    text = "My Profile",
                    fontWeight = FontWeight.Bold
                )
            }
        }
    }
    
    @Composable
    fun FeatureCard(feature: Feature) {
        Card(
            modifier = Modifier.fillMaxWidth(),
            shape = RoundedCornerShape(16.dp),
            colors = CardDefaults.cardColors(containerColor = Color(0xFF1A1A1A)), // dark_surface
            elevation = CardDefaults.cardElevation(defaultElevation = 4.dp)
        ) {
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(20.dp),
                verticalAlignment = Alignment.CenterVertically
            ) {
                Box(
                    modifier = Modifier
                        .size(48.dp)
                        .background(
                            Color(0xFF00FFFF).copy(alpha = 0.2f), // neon_cyan with transparency
                            RoundedCornerShape(12.dp)
                        ),
                    contentAlignment = Alignment.Center
                ) {
                    Icon(
                        imageVector = feature.icon,
                        contentDescription = null,
                        tint = Color(0xFF00FFFF), // neon_cyan
                        modifier = Modifier.size(24.dp)
                    )
                }
                
                Spacer(modifier = Modifier.width(16.dp))
                
                Column(modifier = Modifier.weight(1f)) {
                    Text(
                        text = feature.title,
                        fontSize = 18.sp,
                        fontWeight = FontWeight.Bold,
                        color = Color(0xFFFFFFFF) // text_primary
                    )
                    
                    Spacer(modifier = Modifier.height(4.dp))
                    
                    Text(
                        text = feature.description,
                        fontSize = 14.sp,
                        color = Color(0xFFB3B3B3), // text_secondary
                        lineHeight = 20.sp
                    )
                }
            }
        }
    }
    
    @Composable
    fun StatsSection() {
        Card(
            modifier = Modifier.fillMaxWidth(),
            shape = RoundedCornerShape(16.dp),
            colors = CardDefaults.cardColors(containerColor = Color(0xFF1A1A1A)), // dark_surface
            elevation = CardDefaults.cardElevation(defaultElevation = 8.dp)
        ) {
            Column(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(24.dp)
            ) {
                Text(
                    text = "📊 Platform Statistics",
                    fontSize = 20.sp,
                    fontWeight = FontWeight.Bold,
                    color = Color(0xFF00FFFF), // neon_cyan
                    modifier = Modifier.padding(bottom = 16.dp)
                )
                
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.SpaceEvenly
                ) {
                    StatItem("1,250+", "Active Jobs")
                    StatItem("850+", "Certified Riggers")
                    StatItem("95%", "Success Rate")
                }
            }
        }
    }
    
    @Composable
    fun StatItem(number: String, label: String) {
        Column(
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            Text(
                text = number,
                fontSize = 24.sp,
                fontWeight = FontWeight.Bold,
                color = Color(0xFFFF00FF) // neon_magenta
            )
            Text(
                text = label,
                fontSize = 12.sp,
                color = Color(0xFFB3B3B3) // text_secondary
            )
        }
    }
    
    @Composable
    fun FooterSection() {
        Column(
            modifier = Modifier.fillMaxWidth(),
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            Text(
                text = "🏗️ Built for the Mining Industry",
                fontSize = 16.sp,
                color = Color(0xFF00FFFF), // neon_cyan
                fontWeight = FontWeight.Bold
            )
            
            Spacer(modifier = Modifier.height(8.dp))
            
            Text(
                text = "Enterprise-grade • Mobile-first • Industry-specific",
                fontSize = 12.sp,
                color = Color(0xFFB3B3B3) // text_secondary
            )
            
            Spacer(modifier = Modifier.height(16.dp))
            
            Text(
                text = "© 2024 Tiation • GitHub-based",
                fontSize = 10.sp,
                color = Color(0xFF808080) // text_tertiary
            )
        }
    }
    
    data class Feature(
        val icon: ImageVector,
        val title: String,
        val description: String
    )
    
    private fun getFeaturesList() = listOf(
        Feature(
            Icons.Default.Search,
            "🔍 Smart Job Matching",
            "AI-powered algorithm matches you with relevant jobs based on certifications, location, and experience"
        ),
        Feature(
            Icons.Default.LocationOn,
            "📍 GPS-Based Discovery", 
            "Find jobs near your current location with real-time distance calculations"
        ),
        Feature(
            Icons.Default.AttachMoney,
            "💰 Transparent Pricing",
            "See hourly rates upfront, no hidden fees"
        ),
        Feature(
            Icons.Default.CardMembership,
            "📋 Certification Management",
            "Upload and verify your rigging certifications digitally"
        ),
        Feature(
            Icons.Default.Notifications,
            "⚡ Instant Notifications",
            "Get notified immediately when matching jobs are posted"
        ),
        Feature(
            Icons.Default.Payment,
            "💳 Fast Payment",
            "Automated payment processing via Stripe upon job completion"
        )
    )
    
    @Composable
    fun RiggerHireTheme(content: @Composable () -> Unit) {
        MaterialTheme(
            colorScheme = darkColorScheme(
                primary = Color(0xFF00FFFF), // neon_cyan
                secondary = Color(0xFFFF00FF), // neon_magenta
                background = Color(0xFF0D0D0D), // dark_background
                surface = Color(0xFF1A1A1A), // dark_surface
                onPrimary = Color(0xFF0D0D0D), // text_on_neon
                onSecondary = Color(0xFF0D0D0D), // text_on_neon
                onBackground = Color(0xFFFFFFFF), // text_primary
                onSurface = Color(0xFFFFFFFF) // text_primary
            ),
            content = content
        )
    }
}
