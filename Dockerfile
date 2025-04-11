# Use official Python base image
FROM python:3.10-slim

# Install necessary OS packages for Chrome
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    wget \
    gnupg \
    ca-certificates \
    fonts-liberation \
    libasound2 \
    libatk-bridge2.0-0 \
    libnspr4 \
    libnss3 \
    libxss1 \
    libxcomposite1 \
    libxcursor1 \
    libxdamage1 \
    libxi6 \
    libxtst6 \
    libxrandr2 \
    xdg-utils \
    libu2f-udev \
    libvulkan1 \
    libgbm1 \
    libgtk-3-0 \
    --no-install-recommends && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Google Chrome
RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list && \
    apt-get update && \
    apt-get install -y google-chrome-stable && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy project files
COPY . .

# Unzip wa_profile.zip into wa_profile/ directory
RUN unzip wa_profile.zip -d wa_profile

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Expose port for uvicorn to work (Render expects this)
EXPOSE 10000

# Start FastAPI app via uvicorn
CMD ["uvicorn", "whatsapp_bot:app", "--host", "0.0.0.0", "--port", "10000"]
