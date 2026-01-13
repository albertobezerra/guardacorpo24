const { onSchedule } = require("firebase-functions/v2/scheduler");
const { initializeApp } = require("firebase-admin/app");
const { getFirestore, Timestamp } = require("firebase-admin/firestore");

initializeApp();
const db = getFirestore();

// Roda todo dia às 3h da manhã (horário UTC)
exports.checkExpiredSubscriptions = onSchedule("0 3 * * *", async (event) => {
    const now = Timestamp.now();
    const usersRef = db.collection("users");

    // Busca usuários com assinatura ativa
    const snapshot = await usersRef
        .where("subscriptionStatus", "==", "active")
        .get();

    if (snapshot.empty) {
        console.log("Nenhum usuário ativo encontrado");
        return null;
    }

    const batch = db.batch();
    let expiredCount = 0;

    snapshot.forEach((doc) => {
        const data = doc.data();
        const expiryDate = data.expiryDate;
        const rewardExpiryDate = data.rewardExpiryDate;

        // Verifica se a data principal expirou
        const mainExpired = expiryDate && expiryDate.toDate() < now.toDate();

        // Verifica se a recompensa expirou
        const rewardExpired = rewardExpiryDate && rewardExpiryDate.toDate() < now.toDate();

        // Se AMBAS expiraram, marca como expirado
        if (mainExpired && (rewardExpired || !rewardExpiryDate)) {
            batch.update(doc.ref, {
                subscriptionStatus: "expired",
                planType: "",
            });
            expiredCount++;
            console.log(`Expirado: ${doc.id} - ${data.name || data.email}`);
        }
    });

    if (expiredCount > 0) {
        await batch.commit();
        console.log(`✅ ${expiredCount} assinaturas expiradas atualizadas`);
    } else {
        console.log("Nenhuma assinatura para expirar");
    }

    return null;
});
