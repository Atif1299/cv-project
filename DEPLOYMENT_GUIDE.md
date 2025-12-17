# 🚀 GCP Cloud Run Deployment Guide

## Prerequisites

1. **GCP Account** - Create one at https://cloud.google.com/
2. **GCP Project** - Create a new project in GCP Console
3. **gcloud CLI** - Install from https://cloud.google.com/sdk/docs/install
4. **Docker** - Install from https://www.docker.com/get-started
5. **Git** - For repository connection

---

## 🎯 Quick Deployment (2 Methods)

### Method 1: Automatic Deployment via GitHub (RECOMMENDED)

#### Step 1: Set up GCP Cloud Build
```bash
# 1. Enable APIs
gcloud services enable cloudbuild.googleapis.com
gcloud services enable run.googleapis.com
gcloud services enable containerregistry.googleapis.com

# 2. Grant Cloud Build permissions
PROJECT_NUMBER=$(gcloud projects describe YOUR_PROJECT_ID --format="value(projectNumber)")
gcloud projects add-iam-policy-binding YOUR_PROJECT_ID \
  --member="serviceAccount:${PROJECT_NUMBER}@cloudbuild.gserviceaccount.com" \
  --role="roles/run.admin"

gcloud iam service-accounts add-iam-policy-binding \
  ${PROJECT_NUMBER}-compute@developer.gserviceaccount.com \
  --member="serviceAccount:${PROJECT_NUMBER}@cloudbuild.gserviceaccount.com" \
  --role="roles/iam.serviceAccountUser"
```

#### Step 2: Connect GitHub Repository
1. Go to **GCP Console** → **Cloud Build** → **Triggers**
2. Click **Connect Repository**
3. Select **GitHub** and authenticate
4. Choose your repository
5. Click **Create Trigger**

**Trigger Configuration:**
- **Name:** `deploy-image-captioning`
- **Event:** Push to branch
- **Branch:** `^main$` (or `^master$`)
- **Configuration:** Cloud Build configuration file
- **Location:** `cloudbuild.yaml`

#### Step 3: Push to GitHub
```bash
git add .
git commit -m "Add GCP Cloud Run configuration"
git push origin main
```

**✅ Done! Auto-deployment will trigger on every push to main branch.**

---

### Method 2: Manual Deployment

#### Option A: Using the deploy script
```bash
# 1. Edit deploy.sh and set your PROJECT_ID
nano deploy.sh  # Change YOUR_GCP_PROJECT_ID

# 2. Make it executable
chmod +x deploy.sh

# 3. Run deployment
./deploy.sh
```

#### Option B: Manual commands
```bash
# 1. Set your project
gcloud config set project YOUR_PROJECT_ID

# 2. Build and push image
cd app/app
docker build -t gcr.io/YOUR_PROJECT_ID/image-captioning-app .
docker push gcr.io/YOUR_PROJECT_ID/image-captioning-app

# 3. Deploy to Cloud Run
gcloud run deploy image-captioning-app \
  --image gcr.io/YOUR_PROJECT_ID/image-captioning-app \
  --platform managed \
  --region us-central1 \
  --allow-unauthenticated \
  --memory 4Gi \
  --cpu 2 \
  --timeout 300 \
  --max-instances 10
```

---

## 🔧 Configuration Details

### Resource Allocation
- **Memory:** 4GB (needed for TensorFlow model)
- **CPU:** 2 vCPUs
- **Timeout:** 300 seconds (5 minutes)
- **Max Instances:** 10 (auto-scales based on traffic)

### Estimated Costs
- **Free tier:** 2 million requests/month
- **Running cost:** ~$0.20-0.50 per hour (only when serving requests)
- Cloud Run charges only when your app is processing requests

---

## 🧪 Testing Your Deployment

### Get the URL
```bash
gcloud run services describe image-captioning-app \
  --platform managed \
  --region us-central1 \
  --format 'value(status.url)'
```

### Test with curl
```bash
# Upload an image
curl -X POST https://YOUR-APP-URL/predict \
  -F "image=@test_image.jpg"
```

---

## 🔄 Updating Your App

### With GitHub Auto-Deploy
```bash
# Make changes to your code
git add .
git commit -m "Update feature"
git push origin main
# Auto-deploys in ~5-10 minutes
```

### Manual Update
```bash
# Re-run deployment
./deploy.sh
```

---

## 📊 Monitoring

### View Logs
```bash
gcloud run services logs read image-captioning-app \
  --platform managed \
  --region us-central1
```

### Check Metrics
Go to **GCP Console** → **Cloud Run** → Your Service → **Metrics**

---

## 🐛 Troubleshooting

### Issue: Build fails
```bash
# Check build logs
gcloud builds list --limit 5
gcloud builds log BUILD_ID
```

### Issue: Out of memory
```bash
# Increase memory to 8GB
gcloud run services update image-captioning-app \
  --memory 8Gi \
  --region us-central1
```

### Issue: Slow response
```bash
# Increase CPU and min instances
gcloud run services update image-captioning-app \
  --cpu 4 \
  --min-instances 1 \
  --region us-central1
```

---

## 🔒 Security (Optional)

### Require Authentication
```bash
gcloud run services update image-captioning-app \
  --no-allow-unauthenticated \
  --region us-central1
```

---

## 💰 Cost Optimization

### Set max instances to control costs
```bash
gcloud run services update image-captioning-app \
  --max-instances 5 \
  --region us-central1
```

### Delete service when not needed
```bash
gcloud run services delete image-captioning-app \
  --region us-central1
```

---

## 📝 Important Notes

1. **Model files included:** Ensure `saved/model_5.h5` and `saved/tokenizer.p` are in the repository
2. **Large files:** If model > 100MB, consider using Git LFS or Cloud Storage
3. **Cold starts:** First request after inactivity may be slow (15-30 seconds)
4. **Region:** Change `us-central1` to your preferred region

---

## 🎉 Success Checklist

- [ ] GCP project created
- [ ] gcloud CLI installed and authenticated
- [ ] APIs enabled (Cloud Build, Cloud Run, Container Registry)
- [ ] GitHub repo connected (for auto-deploy)
- [ ] Cloud Build trigger created
- [ ] Code pushed to GitHub
- [ ] Deployment successful
- [ ] App URL accessible
- [ ] Test upload works

---

## 🆘 Support

- **GCP Documentation:** https://cloud.google.com/run/docs
- **Pricing:** https://cloud.google.com/run/pricing
- **Free tier:** https://cloud.google.com/free

**Your app will be live at:** `https://image-captioning-app-XXXXXX-uc.a.run.app`

