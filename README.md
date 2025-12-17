# 🖼️ Image Captioning - Deep Learning Project

> **AI-powered Image Caption Generator using Xception CNN + LSTM**

[![Deploy to Cloud Run](https://img.shields.io/badge/Deploy%20to-Cloud%20Run-blue.svg)](https://cloud.google.com/run)
[![Python 3.10](https://img.shields.io/badge/python-3.10-blue.svg)](https://www.python.org/downloads/)
[![TensorFlow](https://img.shields.io/badge/TensorFlow-2.15-orange.svg)](https://tensorflow.org)

---

## 🎯 Project Overview

This is a deep learning-based **Image Captioning** system that generates natural language descriptions for images. Built as part of NLP Assignment 4 (SP23-BAI-035, SP23-BAI-031, SP23-BAI-042).

### Key Features
- 🧠 **Xception CNN** for image feature extraction
- 📝 **LSTM** for sequential caption generation
- 🌐 **Flask Web App** with modern UI
- ☁️ **Cloud-Ready** - Deploy to GCP Cloud Run in minutes
- 🚀 **Auto-scaling** production-ready deployment

---

## 🏗️ Architecture

```
┌─────────────┐
│   Image     │
│  (299x299)  │
└──────┬──────┘
       │
       ▼
┌──────────────────┐
│  Xception CNN    │
│  (Pre-trained)   │
└──────┬───────────┘
       │
       ▼ (2048 features)
       │
       ├──────────────────────┐
       │                      │
       ▼                      ▼
┌─────────────┐      ┌─────────────┐
│   Dense     │      │  Embedding  │
│   (256)     │      │  + LSTM     │
└──────┬──────┘      └──────┬──────┘
       │                    │
       │    ┌──────────┐    │
       └───►│  Merge   │◄───┘
            └────┬─────┘
                 │
                 ▼
         ┌───────────────┐
         │  Dense (7577) │
         │   (Softmax)   │
         └───────┬───────┘
                 │
                 ▼
           Caption Word
```

**Model Components:**
- **Encoder:** Xception (ImageNet pre-trained)
- **Decoder:** LSTM with Embedding layer
- **Vocabulary:** 7,577 words
- **Max Caption Length:** 34 words
- **Dataset:** Flickr8k (6,000 training images)

---

## 🚀 Quick Deploy to GCP Cloud Run

### Option 1: One-Command Deploy (Fastest)
```bash
gcloud run deploy image-captioning-app \
  --source ./app/app \
  --region us-central1 \
  --allow-unauthenticated \
  --memory 4Gi \
  --cpu 2
```

### Option 2: Auto-Deploy from GitHub
1. Connect your GitHub repo to Cloud Build
2. Push to `main` branch → **Auto-deploys!**

📖 **Detailed Guide:** See [QUICK_START.md](QUICK_START.md) or [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md)

---

## 💻 Local Development

### Prerequisites
- Python 3.10+
- pip

### Setup
```bash
# 1. Clone repository
git clone <your-repo-url>
cd CV

# 2. Install dependencies
cd app/app
pip install -r requirements.txt

# 3. Run locally
python app.py

# 4. Open browser
# http://localhost:5000
```

---

## 📁 Project Structure

```
CV/
├── app/
│   └── app/
│       ├── app.py                 # Flask application
│       ├── requirements.txt       # Python dependencies
│       ├── Dockerfile            # Docker configuration
│       ├── .dockerignore         # Docker ignore rules
│       ├── saved/
│       │   ├── model_5.h5        # Trained model weights
│       │   └── tokenizer.p       # Text tokenizer
│       └── templates/
│           └── index.html        # Web UI
├── main.ipynb                    # Training notebook
├── cloudbuild.yaml               # GCP Cloud Build config
├── deploy.sh                     # Deployment script
├── QUICK_START.md               # Quick deployment guide
├── DEPLOYMENT_GUIDE.md          # Detailed deployment guide
└── README.md                    # This file
```

---

## 🧪 API Usage

### Web Interface
Upload an image at `http://your-url/`

### REST API
```bash
curl -X POST http://your-url/predict \
  -F "image=@path/to/image.jpg"
```

**Response:**
```json
{
  "caption": "a dog is running in the grass"
}
```

---

## 📊 Model Performance

- **Training Dataset:** Flickr8k (6,000 images)
- **Training Loss:** 4.46 → 3.01 (40 epochs)
- **Architecture:** Encoder-Decoder with Attention
- **Feature Dimension:** 2048 → 256
- **LSTM Units:** 256

---

## 🔧 Configuration

### Resource Requirements
- **Memory:** 4GB RAM (minimum)
- **CPU:** 2 vCPUs (recommended)
- **Storage:** ~1GB (model + dependencies)

### Environment Variables
```bash
PORT=8080                    # Server port
PYTHONUNBUFFERED=1          # Enable Python logging
```

---

## 🛠️ Tech Stack

| Component | Technology |
|-----------|-----------|
| **Backend** | Flask (Python) |
| **ML Framework** | TensorFlow/Keras |
| **CNN Model** | Xception |
| **RNN Model** | LSTM |
| **Frontend** | HTML, Bootstrap 5, JavaScript |
| **Deployment** | Docker, GCP Cloud Run |
| **CI/CD** | Cloud Build (optional) |

---

## 📈 Deployment Options

1. **GCP Cloud Run** (Recommended)
   - Auto-scaling
   - Pay-per-use
   - HTTPS included
   - Free tier available

2. **Docker Container**
   ```bash
   docker build -t image-captioning ./app/app
   docker run -p 8080:8080 image-captioning
   ```

3. **Local Flask Server**
   ```bash
   python app.py
   ```

---

## 💰 Cost Estimate (GCP Cloud Run)

- **Free Tier:** 2 million requests/month
- **Beyond Free Tier:** ~$0.20-0.50/hour (only when serving)
- **No idle costs** - scales to zero when not in use

---

## 🎓 Academic Context

**Course:** Natural Language Processing (NLP)  
**Assignment:** A4 - Image Captioning  
**Team Members:**
- SP23-BAI-035
- SP23-BAI-031
- SP23-BAI-042

**Model Approach:**
- Image feature extraction using transfer learning (Xception)
- Sequence-to-sequence caption generation (LSTM)
- Teacher forcing during training
- Greedy decoding during inference

---

## 🤝 Contributing

Feel free to fork this repository and submit pull requests for improvements!

---

## 📄 License

This project is for academic purposes.

---

## 🆘 Troubleshooting

### Issue: Out of Memory
```bash
# Increase memory allocation
gcloud run services update image-captioning-app --memory 8Gi
```

### Issue: Slow Response
- First request after idle may take 15-30 seconds (cold start)
- Consider setting `--min-instances 1` for production

### Issue: Deployment Fails
- Check model files are included in repository
- Ensure `saved/model_5.h5` exists
- Verify all dependencies in requirements.txt

---

## 📞 Support

For deployment issues, check:
- [QUICK_START.md](QUICK_START.md) - Fast setup
- [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md) - Detailed guide
- [GCP Cloud Run Docs](https://cloud.google.com/run/docs)

---

## ⭐ Show Your Support

If this project helped you, please give it a star! ⭐

---

**Built with ❤️ using TensorFlow and Flask**

