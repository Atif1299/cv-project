# 📋 STEP-BY-STEP DEPLOYMENT GUIDE

## ✅ PRE-FLIGHT CHECKLIST

- [ ] GCP account created (with billing enabled)
- [ ] gcloud CLI installed
- [ ] Git installed
- [ ] Model files present (model_5.h5: 60MB, tokenizer.p: 299KB) ✓

---

## 🚀 OPTION 1: FASTEST DEPLOY (5 Minutes)

### Step 1: Install gcloud CLI (Skip if already installed)

**Windows:**
```powershell
# Download installer
https://cloud.google.com/sdk/docs/install

# Or use PowerShell
(New-Object Net.WebClient).DownloadFile("https://dl.google.com/dl/cloudsdk/channels/rapid/GoogleCloudSDKInstaller.exe", "$env:Temp\GoogleCloudSDKInstaller.exe")
& $env:Temp\GoogleCloudSDKInstaller.exe
```

**Mac/Linux:**
```bash
curl https://sdk.cloud.google.com | bash
exec -l $SHELL
```

---

### Step 2: Authenticate with GCP

```bash
gcloud auth login
```
➡️ **Browser will open** → Login with your Google account

---

### Step 3: Create/Set Project

**Option A: Create new project**
```bash
gcloud projects create my-image-caption-001 --name="Image Captioning App"
gcloud config set project my-image-caption-001
```

**Option B: Use existing project**
```bash
# List your projects
gcloud projects list

# Set project
gcloud config set project YOUR_PROJECT_ID
```

---

### Step 4: Enable Billing

⚠️ **Required** - You need a billing account (Free tier available)

1. Go to: https://console.cloud.google.com/billing
2. Link your project to a billing account
3. **Don't worry:** Free tier includes 2M requests/month

---

### Step 5: Deploy! 🚀

```bash
# Navigate to your project root
cd D:\CV

# Deploy in ONE COMMAND
gcloud run deploy image-captioning-app \
  --source ./app/app \
  --region us-central1 \
  --allow-unauthenticated \
  --memory 4Gi \
  --cpu 2
```

**What happens:**
1. ⏳ Uploads your code
2. 🐳 Builds Docker image automatically
3. 📤 Pushes to Container Registry
4. ☁️ Deploys to Cloud Run
5. 🌐 Gives you a public URL!

**Time:** ~5-8 minutes for first deploy

---

### Step 6: Test Your App! 🎉

You'll see output like:
```
Service [image-captioning-app] revision [...] has been deployed and is serving 100 percent of traffic.
Service URL: https://image-captioning-app-abc123-uc.a.run.app
```

**Copy that URL and open in browser!**

---

## 🔄 OPTION 2: AUTO-DEPLOY FROM GITHUB (Production Setup)

### Step 1: Initial Setup (One-time)

```bash
# 1. Set project
gcloud config set project YOUR_PROJECT_ID

# 2. Enable APIs
gcloud services enable cloudbuild.googleapis.com
gcloud services enable run.googleapis.com
gcloud services enable containerregistry.googleapis.com
```

---

### Step 2: Grant Cloud Build Permissions (One-time)

```bash
# Get project number
PROJECT_NUMBER=$(gcloud projects describe YOUR_PROJECT_ID --format="value(projectNumber)")

# Grant Cloud Run Admin role
gcloud projects add-iam-policy-binding YOUR_PROJECT_ID \
  --member="serviceAccount:${PROJECT_NUMBER}@cloudbuild.gserviceaccount.com" \
  --role="roles/run.admin"

# Grant Service Account User role
gcloud iam service-accounts add-iam-policy-binding \
  ${PROJECT_NUMBER}-compute@developer.gserviceaccount.com \
  --member="serviceAccount:${PROJECT_NUMBER}@cloudbuild.gserviceaccount.com" \
  --role="roles/iam.serviceAccountUser"
```

---

### Step 3: Connect GitHub Repository

1. Go to: **https://console.cloud.google.com/cloud-build/triggers**
2. Click **"Connect Repository"**
3. Select **"GitHub"**
4. Click **"Authenticate"** → Allow access
5. Select your repository
6. Click **"Connect"**

---

### Step 4: Create Build Trigger

Click **"Create Trigger"** with these settings:

| Field | Value |
|-------|-------|
| **Name** | `deploy-image-captioning` |
| **Event** | Push to a branch |
| **Branch (regex)** | `^main$` (or `^master$`) |
| **Configuration** | Cloud Build configuration file |
| **Location** | Repository: `cloudbuild.yaml` |

Click **"Create"**

---

### Step 5: Push to GitHub

```bash
# Initialize git (if not already)
cd D:\CV
git init

# Add remote (replace with YOUR repo URL)
git remote add origin https://github.com/yourusername/your-repo.git

# Add all files
git add .

# Commit
git commit -m "Add Image Captioning App with Cloud Run config"

# Push (triggers auto-deploy!)
git push -u origin main
```

---

### Step 6: Monitor Deployment

1. Go to: **https://console.cloud.google.com/cloud-build/builds**
2. Watch your build progress (takes 5-10 minutes)
3. When complete, go to: **https://console.cloud.google.com/run**
4. Click your service to get the URL

**🎉 Now every push to `main` auto-deploys!**

---

## 📊 AFTER DEPLOYMENT

### Get Your Service URL
```bash
gcloud run services describe image-captioning-app \
  --region us-central1 \
  --format 'value(status.url)'
```

### View Logs
```bash
gcloud run services logs read image-captioning-app \
  --region us-central1
```

### Test API
```bash
curl -X POST https://YOUR-APP-URL/predict \
  -F "image=@test_image.jpg"
```

---

## 🔧 COMMON ADJUSTMENTS

### Increase Memory (if app crashes)
```bash
gcloud run services update image-captioning-app \
  --memory 8Gi \
  --region us-central1
```

### Reduce Cold Starts (keep 1 instance always on)
```bash
gcloud run services update image-captioning-app \
  --min-instances 1 \
  --region us-central1
```

### Change Region
```bash
gcloud run deploy image-captioning-app \
  --source ./app/app \
  --region europe-west1 \
  --allow-unauthenticated \
  --memory 4Gi
```

### Limit Max Instances (control costs)
```bash
gcloud run services update image-captioning-app \
  --max-instances 5 \
  --region us-central1
```

---

## 🆘 TROUBLESHOOTING

### Problem: "Billing not enabled"
**Solution:** Go to https://console.cloud.google.com/billing and link billing account

### Problem: "Permission denied"
**Solution:** 
```bash
gcloud auth login
gcloud config set project YOUR_PROJECT_ID
```

### Problem: "Build failed"
**Solution:**
```bash
# Check logs
gcloud builds list
gcloud builds log <BUILD_ID>
```

### Problem: "Service returns 500 error"
**Solution:**
```bash
# Check service logs
gcloud run services logs read image-captioning-app --region us-central1 --limit 50
```

### Problem: "Out of memory"
**Solution:**
```bash
# Increase to 8GB
gcloud run services update image-captioning-app --memory 8Gi --region us-central1
```

### Problem: "Deployment too slow"
**Note:** First deploy takes 5-10 minutes (building + uploading model). This is normal!

### Problem: Model file too large (>100MB)
**Solution:** Use Git LFS
```bash
git lfs install
git lfs track "*.h5"
git add .gitattributes
git commit -m "Add Git LFS"
git push
```

---

## 💰 COST BREAKDOWN

**Free Tier (Monthly):**
- ✅ 2 million requests
- ✅ 360,000 GB-seconds
- ✅ 180,000 vCPU-seconds

**Your App:**
- 4GB memory × 2 vCPU
- ~$0.20-0.50 per hour of **active use**
- **$0 when idle** (auto-scales to zero)

**Example:**
- 1000 requests/day = ~30K requests/month = **FREE**
- Heavy use (100K requests/month) = **~$5-10/month**

---

## ✅ SUCCESS CHECKLIST

- [ ] gcloud CLI installed
- [ ] Authenticated (`gcloud auth login`)
- [ ] Project created/selected
- [ ] Billing enabled
- [ ] App deployed successfully
- [ ] Service URL obtained
- [ ] Test upload works
- [ ] (Optional) GitHub auto-deploy configured

---

## 🎯 NEXT STEPS

1. **Share your URL** with others
2. **Set up custom domain** (optional)
   ```bash
   gcloud beta run domain-mappings create \
     --service image-captioning-app \
     --domain your-domain.com \
     --region us-central1
   ```
3. **Monitor usage** in GCP Console
4. **Set up alerts** for cost/usage
5. **Add authentication** if needed

---

## 📞 NEED HELP?

- 📖 **Quick Commands:** See `COMMANDS.txt`
- 📚 **Detailed Guide:** See `DEPLOYMENT_GUIDE.md`
- 🔗 **GCP Docs:** https://cloud.google.com/run/docs
- 💬 **Stack Overflow:** Tag `google-cloud-run`

---

## 🎉 YOU'RE DONE!

Your image captioning app is now:
- ✅ Live on the internet
- ✅ Auto-scaling (0 to 10 instances)
- ✅ Production-ready
- ✅ HTTPS enabled
- ✅ Global CDN
- ✅ Zero idle cost

**Share your URL and impress your instructor! 🚀**

---

**Final Note:** Your model file (60MB) is within GitHub's limits, but consider Git LFS for future larger models.

