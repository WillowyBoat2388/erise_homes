# **Solution Architecture Document**

## **1. Overview**
This solution enables real-time monitoring of energy consumption across IoT devices in a smart apartment environment. It uses AWS IoT Core for secure ingestion, AWS Lambda and Amazon SNS for immediate alerts, and Amazon Kinesis Data Firehose plus Amazon S3 for large-scale data storage and visualization in Amazon QuickSight.

### **Objectives**
- **Real-time Alerts:** Detect threshold breaches and notify relevant stakeholders instantly.  
- **Scalable Data Ingestion:** Collect large volumes of IoT data without performance bottlenecks.  
- **Analytics & Visualization:** Provide historical and near real-time insights via Amazon QuickSight.  
- **Security:** Enforce end-to-end encryption, strict IAM policies, and certificate-based device authentication.  
- **Cost Efficiency:** Leverage managed, serverless services that scale on demand and incur pay-per-use pricing.

---

## **2. High-Level Architecture**
### IoT Monitoring Architecture

#### Data Flow

```mermaid
graph TD;
    IoTEdge[IoT Edge] -->|TLS, MQTT/HTTPS| IoTCore[AWS IoT Core]
    IoTCore -->|IoT Rule| Kinesis[Kinesis Data Firehose]
    Kinesis --> S3[Amazon S3]
    S3 --> QuickSight[Amazon QuickSight]
    IoTCore -->|IoT Rule| Lambda[AWS Lambda]
    Lambda --> SNS[Amazon SNS]
    
    subgraph Security Management
        KMS[AWS KMS]
        ACM[AWS Certificate Manager]
        IAM[AWS IAM]
    end


1. **IoT Devices** securely connect to **AWS IoT Core** over TLS.  
2. **IoT Rule Engine** checks if data meets specific thresholds:  
   - **Path A:** Forwards data to **Kinesis Data Firehose** for near real-time ingestion into **Amazon S3**.  
   - **Path B:** Triggers an **AWS Lambda** function, which sends alerts via **Amazon SNS** when thresholds are exceeded.  
3. **Amazon QuickSight** reads the data stored in S3 for large-scale visualization and reporting.  
4. **Security Management** uses AWS KMS for encryption, AWS Certificate Manager for device authentication, and AWS IAM for fine-grained access control.

---

## **3. AWS Services and Justifications**

### **3.1 AWS IoT Core**
- **Purpose:** Primary ingestion point for IoT data, supports secure communication via TLS, mutual authentication with X.509 certificates, and a built-in Rules Engine for routing.  
- **Justification:**  
  - **Scalability:** Natively scales to handle millions of devices and messages.  
  - **Low Latency:** Offers MQTT-based real-time messaging.  
  - **Security:** Provides device certificate management, integration with AWS IoT Device Defender.

### **3.2 AWS Lambda**
- **Purpose:** Executes custom logic for threshold checks and integration with SNS.  
- **Justification:**  
  - **Serverless:** No infrastructure to manage, scales automatically.  
  - **Cost-Optimized:** Pay only for execution time.  
  - **Low Latency:** Instant spin-up for event-driven processing.

### **3.3 Amazon SNS**
- **Purpose:** Delivers immediate notifications to stakeholders via email, SMS, or push mechanisms.  
- **Justification:**  
  - **High Availability:** Managed by AWS across multiple Availability Zones.  
  - **Fan-Out Architecture:** Easily add more subscribers without code changes.  
  - **Global Reach:** Supports multiple endpoints and regions for broad alert distribution.

### **3.4 Amazon Kinesis Data Firehose**
- **Purpose:** Provides near real-time, low-latency ingestion of IoT data from AWS IoT Core into Amazon S3.  
- **Justification:**  
  - **Scalability:** Automatically scales to handle variable throughput.  
  - **Cost-Efficient:** Pay for data volume ingested; minimal operational overhead.  
  - **Reliability:** Offers buffering, retries, and fault tolerance.

### **3.5 Amazon S3**
- **Purpose:** Acts as the central data lake for all raw IoT data.  
- **Justification:**  
  - **Durability:** 99.999999999% durability ensures data integrity.  
  - **Cost Optimization:** Tiered storage classes for different access patterns (e.g., S3 Standard, S3 Intelligent-Tiering).

### **3.6 Amazon QuickSight**
- **Purpose:** Visualizes IoT data from S3 in real-time, creating dashboards and reports.
- **Justification:**  
  - **Serverless BI:** No need to manage servers or complex BI infrastructure.  
  - **Scalable & Fast:** SPICE in-memory engine accelerates dashboard queries.  
  - **Extensive Monitoring and Collaboration:** Securely share dashboards with multiple users.

### **3.7 AWS KMS, AWS Certificate Manager, AWS IAM**
- **Purpose:** Provide encryption, certificate management, and access control.  
- **Justification:**  
  - **Security & Compliance:** Ensures data is encrypted in transit and at rest.  
  - **Least Privilege:** IAM roles and policies grant minimal necessary permissions.  
  - **Certificate Rotation:** Automated renewal and rotation of certificates for IoT devices.

---

## **4. Security Implementations**

1. **Device Authentication & TLS**  
   - **X.509 Certificates:** Each IoT device uses a unique certificate to authenticate with AWS IoT Core.  
   - **TLS Encryption:** All data in transit is encrypted via TLS 1.2 or higher.

2. **IAM Roles & Policies**  
   - **Least Privilege:**  
     - IoT Core only has permission to invoke the specific Lambda function and to write data to Firehose/S3.  
     - Lambda has permission to publish to the SNS topic.  
   - **Role Separation:** Different roles for IoT, Lambda, Firehose, and QuickSight ensure blast-radius reduction.

3. **Data Encryption at Rest**  
   - **S3 Server-Side Encryption:** Enabled with AWS KMS-managed keys.  
   - **Kinesis Data Firehose:** Uses KMS to encrypt data in transit and optionally at rest if configured.

4. **Monitoring & Logging**  
   - **CloudWatch Logs:** Lambda, IoT Core, and SNS events are logged for auditing.

5. **Secrets Management**  
   - **AWS Secrets Manager:** Securely stores sensitive info (API keys, encryption keys) for Lambda or other services, rather than embedding them in code or environment variables.

---

## **5. Cost Optimization**

- **Pay-Per-Use Services:**  
  - **AWS IoT Core, Lambda, SNS, Kinesis Firehose** all charge based on the volume of messages or execution time, minimizing idle costs.
- **Tiered Storage in S3:**  
  - **Lifecycle Policies** can automatically transition older data to lower-cost storage classes (e.g., S3 Glacier) if real-time access is not required.

---

## **6. Scalability & Low Latency**

- **Elastic Services:**  
  - **IoT Core** can handle millions of concurrent connections.  
  - **Lambda** automatically scales horizontally to handle spikes in message volume.  
  - **Kinesis Firehose** adapts to traffic surges with built-in buffering and partitioning.
- **MQTT for Real-Time:**  
  - Minimizes overhead and latency, ensuring quick ingestion of sensor data.

---

## **7. Modularity**

- **Infrastructure as Code (IaC) Modules:**  
  - Splitting resources into Terraform modules (IoT, Lambda, SNS, S3, IAM) promotes reuse, consistency, and easier maintenance.
- **Built-In Redundancy:**  
  - Duplication of data ingestion along with Real-time alerts, allowing changes in one path without affecting the other.

---

## **8. Fault Tolerance & Availability**

- **Multi-AZ and Managed Services:**  
  - **AWS IoT Core, Lambda, SNS, Firehose** are multi-AZ compliant, ensuring service continuity if one AZ goes down.
- **Retries & DLQs (Optional):**  
  - Configure Firehose retries or Lambda DLQs (Dead Letter Queues) to handle transient errors and message replay.
- **S3 Durability:**  
  - 11 nines of durability ensures data integrity for stored IoT data.

---

## **9. Conclusion and Next Steps**

This architecture provides a robust, scalable, and cost-effective solution for real-time energy consumption monitoring in a smart apartment context. It addresses key requirements:

- **Immediate Alerts:** IoT Rules + Lambda + SNS  
- **High Availability:** Kinesis Firehose + S3  
- **Analytics & Visualization:** QuickSight dashboards for robust insights
- **Security:** TLS, IAM, KMS encryption  
- **Modular & Fault-Tolerant:** Managed infrastructure with Terraform(IaC)

### **Potential Extensions**
1. **Data Batching(Within IoT Core)**: Utilizing batch processing on the Edge(IoT device level), by local bufering, making use of AWS IoT Greengrass and message queueing, multiple events can be stored in edge device memory  and then published in one MQTT message, effectively reducing the number of invocations(calls made) to downstream services such as AWS Lambda etc.
3. **Edge Processing (AWS IoT Greengrass)**: Reduce cloud latency by running analytics and local actions at the edge.

---

**Author:** [Onidajo Fikayo Wale-Olaitan]  
**Date:** [19/03/2025]  
