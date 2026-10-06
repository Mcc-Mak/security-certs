let modalBody, modal;
let CSV_FILENAME = "";

function escapeHtml(str) {
    if (str === undefined || str === null) return '';
    return str.replace(/[&<>]/g, function (m) {
        if (m === '&') return '&amp;';
        if (m === '<') return '&lt;';
        if (m === '>') return '&gt;';
        return m;
    });
}

function getStatusText(r) {
    if (r.isCorrect) return '<span class="hashtag correct">Correct</span>';
    if (r.userAnswer === "(skipped)") return '<span class="hashtag skipped">Skipped</span>';
    return '<span class="hashtag incorrect">Incorrect</span>';
}

function getStatusLabel(r) {
    if (r.isCorrect) return "Correct";
    if (r.userAnswer === "(skipped)") return "Skipped";
    return "Incorrect";
}

function showModal(results) {
    document.querySelectorAll(`input,select`).forEach(e => e.disabled = true);
    const total = results.length;
    const correctCount = results.filter(r => r.isCorrect).length;
    let html = `<p><strong>Score: ${correctCount}/${total} (${Math.round(correctCount / total * 100)}%)</strong></p>`;
    html += `<div style="overflow-x: auto;"><table class="result-table"><thead><tr><th>Q#</th><th>Your Answer</th><th>Correct Answer</th><th>Result</th><th>Explanation</th></tr></thead><tbody>`;
    results.forEach(r => {
        const statusText = getStatusText(r);
        html += `<tr><td>${r.qid}</td><td>${escapeHtml(r.userAnswer)}</td><td>${escapeHtml(r.correctAnswer)}</td><td>${statusText}</td><td>${escapeHtml(r.explanation)}</td></tr>`;
    });
    html += `</tbody></table></div>`;
    modalBody.innerHTML = html;
    modal.style.display = 'flex';
}

function exportCSV(results) {
    let csvRows = [["Question ID", "User Answer", "Correct Answer", "Result", "Explanation"]];
    results.forEach(r => {
        csvRows.push([r.qid, r.userAnswer, r.correctAnswer, getStatusLabel(r), r.explanation]);
    });
    const csvContent = csvRows.map(row => row.map(cell => `"${String(cell).replaceAll('"', '""')}"`).join(",")).join("\n");
    const blob = new Blob(["\uFEFF" + csvContent], { type: "text/csv;charset=utf-8;" });
    const link = document.createElement("a");
    const url = URL.createObjectURL(blob);
    link.href = url;
    link.setAttribute("download", CSV_FILENAME);
    document.body.appendChild(link);
    link.click();
    link.remove();
    URL.revokeObjectURL(url);
}

function initMCQ(csvFilename, totalQuestions) {
    CSV_FILENAME = csvFilename;
    modal = document.getElementById('summaryModal');
    modalBody = document.getElementById('modalBody');
    const submitBtn = document.getElementById('submitBtn');
    const exportBtn = document.getElementById('exportBtn');
    const closeModal = document.querySelector('.close-modal');
    let currentResults = [];

    submitBtn.addEventListener('click', () => {
        const results = getUserAnswers();
        currentResults = results;
        const correctCount = results.filter(r => r.isCorrect).length;
        document.getElementById('scoreDisplay').innerHTML = `\u2705 Score: ${correctCount}/${totalQuestions} (${Math.round(correctCount / totalQuestions * 100)}%)`;
        showModal(results);
    });

    exportBtn.addEventListener('click', () => {
        if (currentResults?.length) exportCSV(currentResults);
        else alert("Please submit your answers first to generate CSV.");
    });
    document.getElementById('modalExportBtn').addEventListener('click', () => {
        if (currentResults) exportCSV(currentResults);
    });
    closeModal.addEventListener('click', () => { modal.style.display = 'none'; });
    window.addEventListener('click', (e) => { if (e.target === modal) modal.style.display = 'none'; });
}
