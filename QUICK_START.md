# ⚡ QUICK START - Deploy in 5 Minutes

## 🎯 Fastest Way to Deploy

### Step 1: Install gcloud CLI (if not installed)
```bash
# Windows (PowerShell)
(New-Object Net.WebClient).DownloadFile("https://dl.google.com/dl/cloudsdk/channels/rapid/GoogleCloudSDKInstaller.exe", "$env:Temp\GoogleCloudSDKInstaller.exe")
& $env:Temp\GoogleCloudSDKInstaller.exe

# Mac
curl https://sdk.cloud.google.com | bash

# Linux
curl https://sdk.cloud.google.com | bash
```

### Step 2: Login and Setup
```bash
# Login to GCP
gcloud auth login

# Create project (or use existing)
gcloud projects create YOUR-PROJECT-ID --name="Image Captioning"

# Set project
gcloud config set project YOUR-PROJECT-ID

# Enable billing (required - go to console if not enabled)
# https://console.cloud.google.com/billing
```

### Step 3: One-Command Deploy
```bash
# From the root directory of your project
gcloud run deploy image-captioning-app \
  --source ./app/app \
  --platform managed \
  --region us-central1 \
  --allow-unauthenticated \
  --memory 4Gi \
  --cpu 2

# Say YES when prompted
```

**That's it! ✅ Your app is live!**

The command will output your URL:
```
Service URL: https://image-captioning-app-xxxxx-uc.a.run.app
```

---

## 🔄 Auto-Deploy from GitHub (Recommended for Production)

### Quick Setup
```bash
# 1. Enable Cloud Build
gcloud services enable cloudbuild.googleapis.com run.googleapis.com

# 2. Connect your GitHub repo to Cloud Build
# Go to: https://console.cloud.google.com/cloud-build/triggers
# Click "Connect Repository" → Select GitHub → Authorize → Select Repo

# 3. Create trigger with these settings:
#    - Event: Push to branch
#    - Branch: ^main$
#    - Configuration: cloudbuild.yaml

# 4. Push to GitHub
git add .
git commit -m "Deploy to Cloud Run"
git push origin main
```

**Auto-deploys on every push! 🚀**

---

## 🧪 Test Your Deployment

### Browser Test
Just open the URL in your browser and upload an image!

### API Test
```bash
curl -X POST https://YOUR-URL/predict \
  -F "image=@your_image.jpg"
```

---

## 💡 Tips

- **First deploy takes 5-10 minutes** (subsequent deploys are faster)
- **Free tier:** 2 million requests/month
- **Charges only when used** (no idle costs)
- **Auto-scales** from 0 to max instances

---

## 🆘 Problems?

### Build fails?
```bash
# Check logs
gcloud builds list
```

### App crashes?
```bash
# View logs
gcloud run logs read image-captioning-app --region us-central1
```

### Need more memory?
```bash
# Increase to 8GB
gcloud run services update image-captioning-app --memory 8Gi --region us-central1
```

---

## 🎉 Done!

Your image captioning app is now live on Google Cloud Run!

**Next steps:**
- Share your URL with others
- Set up custom domain (optional)
- Monitor usage in GCP Console
- Check DEPLOYMENT_GUIDE.md for advanced features

